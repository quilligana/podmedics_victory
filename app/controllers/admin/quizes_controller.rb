class Admin::QuizesController < ApplicationController
  layout 'admin_application'

  def index
    @questions = UserQuestion.all.order("created_at DESC").paginate(page: params[:page])
  end

end
