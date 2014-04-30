class HostedFilesController < ApplicationController
  before_action :find_video

  def video
    Video.increment_counter(:video_download_count, @video.id)
    url = "http://podmedics-test-harness.s3.amazonaws.com/#{@video.file_name}.mp4"
    download_url(url)
  end

  def audio
    Video.increment_counter(:audio_download_count, @video.id)
    url = "http://podmedics-test-harness.s3.amazonaws.com/audio/#{@video.file_name}.mp3"
    download_url(url)
  end

  def slides
    Video.increment_counter(:slide_download_count, @video.id)
    url = "http://podmedics-test-harness.s3.amazonaws.com/slides/#{@video.file_name}.pdf"
    download_url(url)
  end

  private

    def download_url(url)
      resp = HTTParty.get(url)
      filename  = url
      send_data resp.body,
        :filename => File.basename(filename),
        :content_type => resp.headers['Content-Type']
    end

    def find_video
      @video = Video.friendly.find(params[:video_id])
    end

end
