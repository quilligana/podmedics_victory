class SpecialtyQuestionsController < ApplicationController
  layout 'user_application'
  
  def index
    @specialty = Specialty.friendly.find(params[:specialty_id])
    @user_progress = UserProgress.new(@specialty, current_user)
    @newQuestion = SpecialtyQuestion.new()
  end

  def create
    @specialty = Specialty.friendly.find(params[:specialty_id])
    @question = @specialty.user_questions.new(specialty_question_params)
    @question.user = current_user

    if @question.save
      redirect_to specialty_question_path(id: @question.id)
    else
      redirect_to :back
    end
  end

  def show
    @specialty = Specialty.friendly.find(params[:specialty_id])
    @question = SpecialtyQuestion.find(params[:id])
    @user_progress = UserProgress.new(@specialty, current_user)
    @comment = @question.answers.new()
    @newQuestion = SpecialtyQuestion.new()
  end

  def destroy
  end

  private 

    def specialty_question_params
      params.require(:specialty_question).permit(:content)
    end
end
