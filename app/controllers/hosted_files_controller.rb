class HostedFilesController < ApplicationController
  prepend_before_action :find_video
  before_action :check_subscription

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

    def check_subscription
      if current_user && current_user.is_trial_member?
        redirect_to @video, alert: 'Sorry! Downloads are only available to full members'
      end
    end

    def download_url(url)
      resp = HTTParty.get(url)
      filename  = url
      send_data resp.body,
        :filename => File.basename(filename),
        :disposition => "attachment"
      # start garbage collection manually to fix memory quote exceeded
      GC.start
    end

    def find_video
      @video = Video.friendly.find(params[:video_id])
    end

end
