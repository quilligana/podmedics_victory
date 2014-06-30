class Admin::QuizesController < ApplicationController
  layout 'admin_application'

  def index
    @questions = UserQuestion.includes(:user, question: [:video]).order("created_at DESC").paginate(page: params[:page])
  end

end
