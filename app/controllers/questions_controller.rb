class QuestionsController < ApplicationController
  layout 'user_application'

  def index
    video = Video.friendly.find(params[:video_id])
    @question_ids = video.question_ids
    initiate_questions
  end

  def specialty_index
    specialty = Specialty.friendly.find(params[:id])
    video_ids = specialty.video_ids
    @question_ids = Question.where("video_id IN (?)", video_ids).limit(30).order("RANDOM()").pluck(:id)
    initiate_questions
  end

  def show
    @question = Question.find(params[:id])
    @current_question = session[:current_question]
    @q_ids = session[:q_ids]
    @total_questions = @q_ids.length
    @user_progress = UserProgress.new(@question.video.specialty, current_user)
  end

  def answer
    @current_question = session[:current_question]
    @q_ids = session[:q_ids]
    @q_id = @q_ids[@current_question-1]
    @question = Question.find(@q_id)
    @total_questions = @q_ids.length
    record_answer(params[:answer])
    @user_progress = UserProgress.new(@question.video.specialty, current_user)
    @correct_answer = get_correct_answer
  end

  def result
    @q_ids = session[:q_ids]
    @question = Question.find(@q_ids.first)
    @video = @question.video
    @current_question = session[:current_question]
    @total_questions = @q_ids.length
    @number_correct = session[:correct_answers]
    @user_progress = UserProgress.new(@video.specialty, current_user)
    reset_session
  end

  private

    def initiate_questions
      set_session(@question_ids)
      UserQuestion.register_ids(@question_ids, current_user)
      redirect_to :action => :show, :id => @question_ids.first
    end

    def set_session(ids)
      session[:q_ids] = ids
      session[:current_question] = 1
      session[:correct_answers] = 0
    end

    def update_session
      session[:current_question] += 1
    end

    def reset_session
      session.delete(:q_ids)
      session.delete(:current_question)
      session.delete(:correct_answers)
    end

    def record_answer(answer)
      @answer = answer
      UserQuestion.save_answer(@q_id, current_user, answer)
      continue_questions
    end

    def continue_questions
      if @answer == "true" 
        session[:correct_answers] += 1
      end

      if @current_question < @q_ids.length
        @next_question = Question.find(@q_ids[@current_question])
        update_session
      end
    end

    def get_correct_answer
      case @question.correct_answer
      when 1
        @question.answer_1
      when 2
        @question.answer_2
      when 3
        @question.answer_3
      when 4
        @question.answer_4
      when 5
        @question.answer_5
      end
    end 

end
