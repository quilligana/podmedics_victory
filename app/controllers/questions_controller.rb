class QuestionsController < ApplicationController
  layout 'user_application'

  def index
    # @questions = Question.find_by(video_id: params[:id])
    redirect_to :action => :show, id: Question.first.id
  end

  def show
    @question = Question.find(1)
  end

  def answer
    @correct_answer = params[:correct_answer]
    @next_question = Question.find(2)
    if @correct_answer == "true"

    elsif @correct_answer == "false"

    end
  end
end
