class HostedFilesController < ApplicationController
  before_action :find_video
  before_action :connect_to_s3!

  def video
    url = AWS::S3::S3Object.url_for("#{@video.file_name}.mp4", 'podmedics-test-harness', :expires_in => 2.minutes)
    Video.increment_counter(:video_download_count, @video.id)
    redirect_to url
  end

  def audio
    url = AWS::S3::S3Object.url_for("/audio/#{@video.file_name}.mp3", 'podmedics-test-harness', :expires_in => 2.minutes)
    Video.increment_counter(:audio_download_count, @video.id)
    redirect_to url
  end

  def slides
    url = AWS::S3::S3Object.url_for("/slides/#{@video.file_name}.pdf", 'podmedics-test-harness', :expires_in => 2.minutes)
    Video.increment_counter(:slide_download_count, @video.id)
    redirect_to url
  end

  private

    def connect_to_s3!
      AWS::S3::DEFAULT_HOST.replace 's3-eu-west-1.amazonaws.com'
      AWS::S3::Base.establish_connection!(
        access_key_id: ENV['AWS_ACCESS_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS']
      )
    end

    def find_video
      @video = Video.friendly.find(params[:video_id])
    end

end
