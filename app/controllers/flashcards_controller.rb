class FlashcardsController < ApplicationController
  layout 'user_application'

  def new
    @video = Video.friendly.find(params[:video_id])
    @flashcard = Flashcard.new
  end

  def create
  end

end