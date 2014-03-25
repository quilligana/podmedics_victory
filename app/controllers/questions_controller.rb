class QuestionsController < ApplicationController
  layout 'user_application'

  def index
    @video = Video.friendly.find(params[:video_id])
    @question_ids = @video.question_ids
    set_session(@question_ids)
    UserQuestion.register_ids(@question_ids, current_user)
    redirect_to :action => :show, :id => @question_ids.first
  end

  def show
    @question = Question.find(params[:id])
  end

  def answer 
    @current_question = session[:current_question]
    @q_ids = session[:q_ids]
    record_answer(params[:answer])
    @correct_answer = get_correct_answer
  end

  def result
    @q_ids = session[:q_ids]
    @video = Question.find(@q_ids.first).video
    @total_questions = @q_ids.length
    @number_correct = session[:correct_answers]
    reset_session
  end

  private

    def reset_session
      session.delete(:q_ids)
      session.delete(:current_question)
      session.delete(:correct_answers)
    end

    def set_session(ids)
      session[:q_ids] = ids
      session[:current_question] = 0
      session[:correct_answers] = 0
    end

    def update_session
      session[:current_question] += 1
    end

    def record_answer(answer)
      @answer = answer
      @q_id = @q_ids[@current_question]
      @question = Question.find(@q_id)
      user_question = UserQuestion.where(question_id: @q_id).where(user_id: current_user.id).first

      if answer == "true" && user_question.correct_answer == false
        user_question.update_attributes(correct_answer: true)
      end

      if answer == "true" 
        session[:correct_answers] += 1
      end

      if @current_question < @q_ids.length - 1
        @next_question = Question.find(@q_ids[@current_question + 1])
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
