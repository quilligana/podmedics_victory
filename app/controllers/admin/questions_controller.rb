class Admin::QuestionsController < ApplicationController
  layout 'admin_application'

  def new
    @video = Video.friendly.find(params[:video_id])
    @question = @video.questions.new
  end

  def create
    @video = Video.friendly.find(params[:video_id]) 
    @question = @video.questions.create(permitted_params)
    if @question.save
      redirect_to admin_video_path(@video), notice: 'Question added'
    else
      flash.now.alert = 'Please review the form'
      render :new
    end
  end

  protected

  def permitted_params
    params.require(:question).permit(:stem, :answer_1, :answer_2, :answer_3, :answer_4, :answer_5,
                                    :correct_answer, :explanation)
  end

end
