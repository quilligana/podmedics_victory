class VideosController < ApplicationController
  layout 'user_application'

  def show
    @video = Video.friendly.find(params[:id])
    Vimeo.register_ids(@video.id, current_user)
    @comment = Comment.new(user: current_user)
    @notes = @video.note || Note.new()
  end

end
