class VideosController < ApplicationController
  layout 'user_application'

  def show
    @video = Video.friendly.find(params[:id])
    @video.increment_views
    Vimeo.register_ids(@video.id, current_user)
    @comment = Comment.new(user: current_user)
    @notes = @video.notes.find_by(user: current_user) || Note.new(noteable: @video)
  end

end
