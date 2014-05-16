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
      AdminMailer.delay.new_specialty_question(@specialty)
      redirect_to specialty_question_path(id: @question.id)
    else
      redirect_to :back
    end
  end
  
  def index
    @questions = @specialty.cached_specialty_questions(1)
  end

  def show
    @question = SpecialtyQuestion.find(params[:id])
    @comment = @question.answers.new()
    @answers = @question.cached_answers
    @owner = @question.cached_user
  end

  def load
    # Using will-paginate to get the SpecialtyQuestions in chunks.
    # Amount on each page defined in constants.rb
    @questions = @specialty.cached_specialty_questions(params[:page])

    # This is the page number that will be included in the new 'load more questions' link.
    @next_page_number = params[:page].to_i + 1

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @question = SpecialtyQuestion.find(params[:id])
    
    if @question.cached_user == current_user
      @question.destroy
    end

    redirect_to specialty_questions_path(@question.specialty)
  end

  private 

    def specialty_question_params
      params.require(:specialty_question).permit(:content)
    end

    def get_specialty
      @specialty = Specialty.cached_friendly_find(params[:specialty_id])
    end

    def load_user_progress
      @user_progress = UserProgress.new(@specialty, current_user)
    end

    def new_question
      @newQuestion = SpecialtyQuestion.new()
    end

    def load_specialty_notes
      @notes = @specialty.cached_specialty_note(current_user) || Note.new(noteable: @specialty)
    end

end
