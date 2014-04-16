class VimeosController < ApplicationController

  def paused
    @vimeo = current_user.vimeos.where(video_id: params[:id]).first
    @vimeo.update_attributes(progress, params[:progress])
    head :accepted
  end

  def completed
    @vimeo = current_user.vimeos.where(video_id: params[:id]).first
    @vimeo.update_attributes(completed, true)
    head :accepted
  end

end