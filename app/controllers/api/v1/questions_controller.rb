class API::V1::QuestionsController < ApplicationController
  respond_to :json

  def default_serializer_options
    {root: false}
  end

  def index
    @questions = Question.includes(:video).order(:id)
    respond_with @questions
  end

end
