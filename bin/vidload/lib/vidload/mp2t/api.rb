require "playwright"
require "thread"

module Vidload::Mp2t::Api
  DEMUXER_PATH = "#{__dir__}/demuxer.sh"
  VIDEO_DOWNLOADED_EVENT_QUEUE = Queue.new

  class Downloader
    attr_reader :video_url, :video_name, :hls_url, :master_playlist_name, :playwright_cli_path, :video_referer

    def initialize(
      video_url:,
      video_name:,
      hls_url:,
      master_playlist_name:,
      playwright_cli_path:,
      video_referer:
    )
      raise ArgumentError, "video_url must be provided" unless video_url
      raise ArgumentError, "video_name must be provided" unless video_name
      raise ArgumentError, "hls_url must be provided" unless hls_url
      raise ArgumentError, "master_playlist_name must be provided" unless master_playlist_name
      raise ArgumentError, "playwright_cli_path must be provided" unless playwright_cli_path
      raise ArgumentError, "video_referer must be provided" unless video_referer

      @video_url = video_url
      @video_name = video_name
      @hls_url = hls_url
      @master_playlist_name = master_playlist_name
      @playwright_cli_path = playwright_cli_path
      @video_referer = video_referer
    end

    def self.from_argv
      new(
        video_url: ARGV[0],
        video_name: ARGV[1],
        hls_url: ARGV[2],
        master_playlist_name: ARGV[3],
        playwright_cli_path: ARGV[4],
        video_referer: ARGV[5]
      )
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

    private

    def manage_video_download(page, *video_starter_callbacks)
      page.on("request", -> (req) { listen_to_video_starts(req) })
      navigate_to_url(@video_url, page)
      video_starter_callbacks.each do |callback|
        callback.call(page)
      end
    end

    def wait_until_video_downloaded
      VIDEO_DOWNLOADED_EVENT_QUEUE.pop
    end

    def listen_to_video_starts(request)
      if request.url.start_with?(@hls_url) && request.url.include?(@master_playlist_name)
        puts "Video starts. Starting download..."
        system(DEMUXER_PATH, request.url, @video_name, @video_referer)
        puts "✔ Video downloaded successfully! Available in ./#{@video_name}.mp4"
        VIDEO_DOWNLOADED_EVENT_QUEUE << true
      end
    end

    def navigate_to_url(url, page)
      print "Page #{url} loading..."
      page.goto(url)
      print "\r"
      print " " * 16 + " " * url.length
      print "\r"
      puts "Page #{url} loaded!"
    end
  end
end
