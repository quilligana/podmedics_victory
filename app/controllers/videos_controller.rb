class VideosController < ApplicationController

  def show
    @video = Video.friendly.find(params[:id])
  end

end
