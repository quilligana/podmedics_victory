class Admin::FlashcardsController < ApplicationController
  layout 'admin_application'
  respond_to :html, :json

  def index
    @filterrific = initialize_filterrific(
      Flashcard,
      params[:filterrific],
      select_options: {
        sorted_by: Flashcard.options_for_sorted_by
      }
    ) or return

    @flashcards = @filterrific.find

    respond_to do |format|
      format.html
      format.js
    end

  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) and return
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

  def approve
    @flashcard = Flashcard.find(params[:id])
    @flashcard.approve
    redirect_to admin_flashcards_path, notice: 'Flashcard approved'
  end

  def destroy
    @flashcard = Flashcard.find(params[:id])
    @flashcard.destroy
    redirect_to admin_flashcards_path, notice: 'Flashcard removed'
  end

  private

  def flashcard_params
    params.require(:flashcard).permit(:title, :video_id, :specialty_id, :epidemiology,
                                      :pathology, :causes, :signs, :symptoms, :inv_cultures,
                                      :inv_bloods, :inv_imaging, :inv_scopic, :inv_functional,
                                      :treat_cons, :treat_medical, :treat_surgical, :approved, :user_id)
  end
end
