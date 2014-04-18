class VimeosController < ApplicationController

  def paused
    get_video(params[:path])
    vimeo = current_user.vimeos.where(video_id: @video_id).first
    vimeo.update_attributes(progress: params[:progress])
    head :accepted
  end

  def completed
    get_video(params[:path])
    vimeo = current_user.vimeos.where(video_id: @video_id).first
    unless vimeo.completed
      vimeo.update_attributes(completed: true)
    end
    head :accepted
  end

  private

  def get_video(path)
    video_name = path.gsub(/\/videos\//, "")
    @video_id = Video.friendly.find(video_name).id
  end

end