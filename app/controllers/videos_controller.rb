class VideosController < ApplicationController
  layout 'user_application'

  def index
    if params[:tag]
      @videos = Video.tagged_with(params[:tag])
    elsif params[:search]
      @videos = Video.search(params[:search])
    else
      @videos = Video.all
    end
  end

  def show
    @video = Video.friendly.find(params[:id])
    @specialty = Specialty.cached_find(@video.specialty_id)
    @video.increment_views
    Vimeo.register_ids(@video.id, current_user)
    @comment = Comment.new(user: current_user)
    @notes = @video.notes.find_by(user: current_user) || Note.new(noteable: @video)
  end

end
