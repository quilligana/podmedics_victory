class SpecialtyQuestionsController < ApplicationController
  layout 'user_application'

  before_action :get_specialty, only: [:create, :index, :show, :load]
  before_action :load_user_progress, only: [:show, :index]
  before_action :new_question, only: [:show, :index]
  before_action :load_specialty_notes, only: [:show, :index]

  def create
    @question = @specialty.user_questions.new(specialty_question_params)
    @question.user = current_user

    if @question.save
      redirect_to specialty_question_path(id: @question.id)
    else
      redirect_to :back
    end
  end
  
  def index
    @questions = SpecialtyQuestion.where(specialty_id: @specialty.id).page(1).order('created_at DESC')
  end

  def show
    @question = SpecialtyQuestion.find(params[:id])
    @comment = @question.answers.new()
    @comments = @question.get_answers
    @owner = @question.user
  end

  def load
    # Using will-paginate to get the SpecialtyQuestions in chunks.
    # Amount on each page defined in constants.rb
    @questions = SpecialtyQuestion.where(specialty_id: @specialty.id).page(params[:page]).order('created_at DESC')

    # This is the page number that will be included in the new 'load more questions' link.
    @next_page_number = params[:page].to_i + 1

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @question = SpecialtyQuestion.find(params[:id])
    
    if @question.user == current_user
      @question.destroy
    end

    redirect_to specialty_questions_path(@question.specialty)
  end

  private 

    def specialty_question_params
      params.require(:specialty_question).permit(:content)
    end

    def get_specialty
      @specialty = Specialty.friendly.find(params[:specialty_id])
    end

    def load_user_progress
      @user_progress = UserProgress.new(@specialty, current_user)
    end

    def new_question
      @newQuestion = SpecialtyQuestion.new()
    end

    def load_specialty_notes
      @notes = @specialty.notes.find_by(user: current_user) || Note.new(noteable: @specialty)
    end

end
