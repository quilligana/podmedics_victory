class SpecialtyQuestionsController < ApplicationController
  def index
    @specialty = Specialty.friendly.find(params[:specialty_id])
    @user_progress = UserProgress.new(@specialty, current_user)
    @videos = @specialty.videos
  end

  def create
  end

  def show
  end

  def destroy
  end
end
