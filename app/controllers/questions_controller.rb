class QuestionsController < ApplicationController
  layout 'user_application'

  def index
    video = Video.friendly.find(params[:video_id])
    @question_ids = video.question_ids
    initiate_questions
  end

  def specialty_index
    specialty = Specialty.cached_friendly_find(params[:id])
    video_ids = specialty.video_ids
    @question_ids = Question.where("video_id IN (?)", video_ids).limit(30).order("RANDOM()").pluck(:id)
    if current_user.is_trial_member? && !current_user.has_access_to?(specialty)
      redirect_to specialty_path(specialty), alert: 'You have not yet unlocked this specialty'
    else
      initiate_questions
    end
  end

  def show
    @quiz = Quiz.new(session)
    @user_progress = UserProgress.new(@quiz.video.specialty, current_user)
  end

  def answer
    @quiz = Quiz.new(session)
    @user_progress = UserProgress.new(@quiz.video.specialty, current_user)
    process_answer(params[:answer_given])
  end

  def result
    @quiz = Quiz.new(session)
    @user_progress = UserProgress.new(@quiz.video.specialty, current_user)
    reset_session
  end

private

  def initiate_questions
    set_session(@question_ids)
    UserQuestion.register_ids(@question_ids, current_user)
    redirect_to :action => :show, :id => @question_ids.first
  end

  def process_answer(answer_number)
    if @quiz.answered_correct?(answer_number.to_i)
      @quiz.record_answer(current_user, answer_number.to_i)
      session[:correct_answers] += 1
    end
    update_session
  end

  def set_session(ids)
    session[:q_ids] = ids
    session[:current_question] = 1
    session[:correct_answers] = 0
  end

  def update_session
    session[:current_question] += 1 if @quiz.active?
  end

  def reset_session
    session.delete(:q_ids)
    session.delete(:current_question)
    session.delete(:correct_answers)
  end

end
