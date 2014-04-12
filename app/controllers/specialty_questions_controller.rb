class SpecialtyQuestionsController < ApplicationController
  layout 'user_application'
  
  def index
    @specialty = Specialty.friendly.find(params[:specialty_id])
    @questions = SpecialtyQuestion.page(1).order('created_at DESC')
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

    @comments = @question.get_answers
  end

  def load
    @specialty = Specialty.friendly.find(params[:specialty_id])
    @questions = SpecialtyQuestion.page(params[:page]).order('created_at DESC')
    @next_page_number = params[:page].to_i + 1

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @question = SpecialtyQuestion.find(params[:id])
    if @question.user == current_user
      @question = SpecialtyQuestion.find(params[:id])
      @question.destroy
    end

    redirect_to specialty_questions_path(@question.specialty)
  end

  private 

    def specialty_question_params
      params.require(:specialty_question).permit(:content)
    end
end
