class VideosController < ApplicationController
  layout 'user_application'

  def show
    @video = Video.friendly.find(params[:id])
    @comment = Comment.new(user: current_user)
  end

end
