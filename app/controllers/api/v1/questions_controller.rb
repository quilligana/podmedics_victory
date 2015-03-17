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
    amount = params[:quantity].to_i if params[:quantity]
    @questions = Question.all.uniq_by(&:specialty_id).take(amount || 10)
    respond_with @questions
  end

  def count
    @count = Question.count
    respond_with @count
  end

end
