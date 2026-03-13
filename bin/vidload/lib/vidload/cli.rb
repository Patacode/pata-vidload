# frozen_string_literal: true

require 'thor'

module Vidload
  class Cli < Thor
    desc 'mp2t VIDEO_URL', 'download a mp2t containerized video'
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
        **options
      }

      process_mp2t(params)
    end

    private

    def process_mp2t(params)
      raise NotImplementedError
    end
  end
end
