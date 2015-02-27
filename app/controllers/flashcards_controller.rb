class FlashcardsController < ApplicationController
  layout 'user_application'

  def new
    @flashcard = Flashcard.new
  end

  def create
  end

end