class API::V1::QuestionsController < ApplicationController
  respond_to :json

  def default_serializer_options
    {root: false}
  end

  def index
    @questions = Question.includes(:video).order(:id)
    respond_with @questions
  end

  def sample
    @specialties = Specialty.take(params[:quantity] || 10)
    @questions = []
    @specialties.each do |specialty|
      @questions.push(specialty.questions.first)
    end
    respond_with @specialties
  end

  def count
    @count = Question.count
    respond_with @count
  end

end
