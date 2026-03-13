require "playwright"
require "thread"
require "tty-spinner"
require "open3"
require "m3u8"
require "io/console"

module Vidload::Mp2t::Api
  DEMUXER_PATH = "#{__dir__}/remuxer.sh"
  VIDEO_DOWNLOADED_EVENT_QUEUE = Queue.new
  VIDEO_INDEX_EVENT_QUEUE = Queue.new
  ANSI_BOLD_WHITE="\033[1;97m"
  ANSI_LIGHT_GREY="\033[37m"
  ANSI_RESET="\033[0m"

  class Downloader
    attr_reader :video_url, :video_name, :hls_url, :master_playlist_name, :playwright_cli_path, :video_referer

    def initialize(
      video_url:,
      video_name:,
      author_name:,
      hls_url:,
      master_playlist_name:,
      playwright_cli_path:,
      video_referer:,
      ts_seg_pattern:,
      hls_index_pattern:,
      output_dir:
    )
      raise ArgumentError, "video_url must be provided" unless video_url
      raise ArgumentError, "hls_url must be provided" unless hls_url
      raise ArgumentError, "master_playlist_name must be provided" unless master_playlist_name
      raise ArgumentError, "playwright_cli_path must be provided" unless playwright_cli_path
      raise ArgumentError, "video_referer must be provided" unless video_referer
      raise ArgumentError, "ts_seg_pattern must be provided" unless ts_seg_pattern
      raise ArgumentError, "hls_index_pattern must be provided" unless hls_index_pattern

      @video_url = video_url
      @hls_url = hls_url
      @master_playlist_name = master_playlist_name
      @playwright_cli_path = playwright_cli_path
      @video_referer = video_referer
      @ts_seg_pattern = ts_seg_pattern
      @hls_index_pattern = hls_index_pattern
      @max_lines = IO.console.winsize[0]
      @author_name = author_name
      @video_name = if @author_name then "#{@author_name}_#{video_name}" else nil end
      @output_dir = output_dir || "./" 
    end

    def self.from_argv
      new(
        video_url: ARGV[0],
        video_name: ARGV[1],
        hls_url: ARGV[2],
        master_playlist_name: ARGV[3],
        playwright_cli_path: ARGV[4],
        video_referer: ARGV[5],
        ts_seg_pattern: ARGV[6],
        hls_index_pattern: ARGV[7],
        author_name: ARGV[8],
      )
    end

    def self.from_hash(hash)
      new(
        video_url: hash[:video_url],
        author_name: hash[:author_name],
        video_name: hash[:video_name],
        hls_url: hash[:hls_url],
        master_playlist_name: hash[:master_playlist_name],
        playwright_cli_path: hash[:playwright_cli_path],
        video_referer: hash[:video_referer],
        ts_seg_pattern: hash[:ts_seg_pattern],
        hls_index_pattern: hash[:hls_index_pattern],
      )
    end

    # main func to be called in your own scripts defined under web/
    def download_video(video_starter_callbacks: [])
      Playwright.create(playwright_cli_executable_path: @playwright_cli_path) do |playwright|
        browser = playwright.chromium.launch
        page = browser.new_page

        manage_video_download(page, *video_starter_callbacks)
        wait_until_video_downloaded

        browser.close
      end
    end

    def display_calling_args
      puts "Constants:"
      puts "\tDEMUXER_PATH=#{DEMUXER_PATH}"
      puts "Called with:"
      puts "\tvideo_url=#{@video_url}"
      puts "\tvideo_name=#{@video_name}"
      puts "\thls_url=#{@hls_url}"
      puts "\tmaster_playlist_name=#{@master_playlist_name}"
      puts "\tplaywright_cli_path=#{@playwright_cli_path}"
      puts "\tvideo_referer=#{@video_referer}"
      puts "\tts_seg_pattern=#{@ts_seg_pattern}"
      puts "\thls_index_pattern=#{@hls_index_pattern}"
      puts "\tauthor_name=#{@author_name}"
    end

    def self.display_with_spinner(loading_msg = "Loading...")
      spinner = TTY::Spinner.new("[:spinner] #{loading_msg}")
      spinner.auto_spin
      yield
      spinner.success("(done)")
    end

    private

    def manage_video_download(page, *video_starter_callbacks)
      @seg_qty = nil
      @pending_hls_response = nil
      @lines = [""] * @max_lines
      page.on("response", -> (resp) { listen_to_video_starts(resp) })
      navigate_to_url(@video_url, page)
      video_starter_callbacks.each do |callback|
        res = callback.call(page)
        if !@video_name && res[:video_name]
          @video_name = res[:video_name]
        end
        if !@author_name && res[:author_name]
          @author_name = res[:author_name]
          @video_name = "#{@author_name}_#{@video_name}"
        end
      end
    end

    def wait_until_video_downloaded
      VIDEO_DOWNLOADED_EVENT_QUEUE.pop
    end

    def trigger_video_download(video_url, seg_qty)
      puts "Video starts. Starting download..."
      run_cmd(DEMUXER_PATH, video_url, "#{@output_dir}#{@video_name}", @video_referer) do |line|
        if (line.include?("hls @") || line.include?("https @")) && line.match?(/#{@ts_seg_pattern}/i)
          seg_nb = line.match(/#{@ts_seg_pattern}/i)[:seg_nb]
          add_line(line)
          progress_bar(seg_nb, seg_qty)
        end
      end
      print "\r\e[2K"
      puts "✔ Video downloaded successfully! Available in #{@output_dir}#{@video_name}.mp4"
      VIDEO_DOWNLOADED_EVENT_QUEUE << true
    end

    def listen_to_video_starts(response)
      if response.url.start_with?(@hls_url) && response.url.match?(/#{@hls_index_pattern}/i)
        body = response.text
        playlist = M3u8::Playlist.read(body)
        last_item = playlist.items.last.segment
        match = last_item.match(/#{@ts_seg_pattern}/i)
        @seg_qty = match[:seg_nb].to_i

        if @pending_hls_response
          trigger_video_download(@pending_hls_response.url, @seg_qty)
        end
      elsif response.url.start_with?(@hls_url) && response.url.include?(@master_playlist_name)
        if @seg_qty
          trigger_video_download(response.url, @seg_qty)
        else
          @pending_hls_response = response
        end
      end
    end

    def navigate_to_url(url, page)
      Downloader.display_with_spinner("Page #{url} loading...") do
        page.goto(url)
      end
    end

    def run_cmd(*cmd)
      Open3.popen2e(*cmd) do |_stdin, stdout_and_stderr, wait_thr|
        stdout_and_stderr.each_line do |line|
          yield line
        end
      end
    end

    def redraw_lines()
      return if @lines.empty?

      printf "\e[H"
      printf "\e[0J"

      _rows, cols = IO.console.winsize
      @lines.each do |line|
        if line.length > cols
          puts "#{line.slice(0, cols - 3)}..."
        else
          puts line
        end
      end
    end

    def add_line(line)
      @lines << line
      @lines.shift if @lines.size > @max_lines
      redraw_lines()
    end

    def progress_bar(current, total, width: 40)
      ratio = current.to_f / total
      filled = (ratio * width).round
      empty = width - filled

      bar = "█" * filled + "░" * empty
      percent = (ratio * 100).round(1)

      print "\r[#{bar}] #{percent}% (#{current}/#{total})"
    end
  end
end
