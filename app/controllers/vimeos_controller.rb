class VimeosController < ApplicationController

  def paused
    Vimeo.delay.pause_video(current_user.id, params)
    head :accepted
  end

  def completed
    Vimeo.delay.video_completed(current_user.id, params)
    head :accepted
  end
end