class Admin::FlashcardsController < ApplicationController
  layout 'admin_application'
  respond_to :html, :json

  def index
    @flashcards = Flashcard.all.order(:title)
  end

  def new
    @flashcard = Flashcard.new
  end

  def create
    @flashcard = Flashcard.new(flashcard_params)
    if @flashcard.save
      redirect_to admin_flashcards_path, notice: 'New flashcard added'
    else
      render :new
    end
  end

  def edit
    @flashcard = Flashcard.find(params[:id])
  end

  def update
    @flashcard = Flashcard.find(params[:id])
    if @flashcard.update_attributes(flashcard_params)
      redirect_to admin_flashcards_path, notice: 'Video updated'
    else
      render :edit
    end
  end

  private

  def flashcard_params
    params.require(:flashcard).permit(:title, :video_id, :specialty_id, :epidemiology,
                                      :pathology, :causes, :signs, :symptoms, :inv_cultures,
                                      :inv_bloods, :inv_imaging, :inv_scopic, :inv_functional,
                                      :treat_cons, :treat_medical, :treat_surgical, :approved)
  end
end