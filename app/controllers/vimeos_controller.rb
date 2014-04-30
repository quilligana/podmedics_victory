class VimeosController < ApplicationController

  def paused
  	# NEEDS FIXING
  	# Delay is preventing the cache from being flushed for some reason if we include
  	# it in pause_video or video_completed so we need to flush it out here
  	Vimeo.flush_cache(current_user.id, params)
    Vimeo.delay.pause_video(current_user.id, params)
    head :accepted
  end

  def completed
  	# NEEDS FIXING
  	# Delay is preventing the cache from being flushed for some reason if we include
  	# it in pause_video or video_completed so we need to flush it out here
  	Vimeo.flush_cache(current_user.id, params)
    Vimeo.delay.video_completed(current_user.id, params)
    head :accepted
  end
end