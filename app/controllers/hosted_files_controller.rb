class HostedFilesController < ApplicationController
  prepend_before_action :find_video
  before_action :check_subscription

  def video
    Video.increment_counter(:video_download_count, @video.id)
    s3_name = "#{@video.file_name}.mp4"
    redirect_to generate_download_url(s3_name)
  end

  def audio
    Video.increment_counter(:audio_download_count, @video.id)
    s3_name = "audio/#{@video.file_name}.mp3"
    redirect_to generate_download_url(s3_name)
  end

  def slides
    Video.increment_counter(:slide_download_count, @video.id)
    s3_name = "slides/#{@video.file_name}.pdf"
    redirect_to generate_download_url(s3_name)
  end

  private

    def generate_download_url(file_path)
      s3 = AWS::S3.new(
        :access_key_id => ENV["AWS_ACCESS_ID"],
        :secret_access_key => ENV["AWS_SECRET_ACCESS"]
      )
      #bucket = s3.buckets['podmedics-test-harness']
      bucket = s3.buckets['podmedics-resources']
      object = bucket.objects[file_path]
      url = object.url_for(:read, :expires => 10*60).to_s
    end

    def check_subscription
      if current_user && current_user.is_trial_member?
        redirect_to @video, alert: 'Sorry! Downloads are only available to full members'
      end
    end

    def find_video
      @video = Video.friendly.find(params[:video_id])
    end

end
