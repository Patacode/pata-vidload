require "thor"

class Vidload::Cli < Thor
  desc "mp2t VIDEO_URL", "download a mp2t containerized video"
  method_option :video_name, type: :string, required: false
  method_option :author_name, type: :string, required: false
  method_option :output_dir, type: :string, required: false
  method_option :hls_url, type: :string, required: true
  method_option :master_playlist_name, type: :string, required: true
  method_option :playwright_cli_path, type: :string, required: true
  method_option :video_referer, type: :string, required: true
  method_option :ts_seg_pattern, type: :string, required: true
  method_option :hls_index_pattern, type: :string, required: true
  def mp2t(video_url)
    params = {
      video_url: video_url,
      video_name: options[:video_name],
      hls_url: options[:hls_url],
      master_playlist_name: options[:master_playlist_name],
      playwright_cli_path: options[:playwright_cli_path],
      video_referer: options[:video_referer],
      ts_seg_pattern: options[:ts_seg_pattern],
      hls_index_pattern: options[:hls_index_pattern],
      author_name: options[:author_name],
      output_dir: options[:output_dir],
    }

    process_mp2t(params)
  end

  private 

  def process_mp2t(params)
    raise NotImplementedError
  end
end
