class API::V1::QuestionsController < ApplicationController
  respond_to :json

  def default_serializer_options
    {root: false}
  end

  def index
    @questions = Question.order(:id)
    respond_with @questions
  end

  def sample
    @questions = Question.all.uniq_by(&:specialty_id).take(params[:quantity].to_i || 10)
    respond_with @questions
  end

  def count
    @count = Question.count
    respond_with @count
  end

end
