class FlashcardsController < ApplicationController
  layout 'user_application'

  def new
    @video = Video.friendly.find(params[:video_id])
    @flashcard = Flashcard.new
  end

  def create
    @video = Video.friendly.find(params[:video_id])
    @flashcard = Flashcard.new(flashcard_params)
    @flashcard.title = @video.title
    @flashcard.video_id = @video.id
    @flashcard.specialty_id = @video.specialty_id
    @flashcard.user_id = current_user.id
    if @flashcard.save
      redirect_to @video, notice: 'Thank you. Your flashcard has been submitted and will be reviewed.'
    else
      flash.now[:error] = 'Please review the form'
      render :new
    end
  end

  private

  def flashcard_params
    params.require(:flashcard).permit(:title, :video_id, :specialty_id, :epidemiology,
                                      :pathology, :causes, :signs, :symptoms, :inv_cultures,
                                      :inv_bloods, :inv_imaging, :inv_scopic, :inv_functional,
                                      :treat_cons, :treat_medical, :treat_surgical, :user_id)
  end

end