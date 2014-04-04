class SpecialtiesController < ApplicationController
  layout 'user_application'

  def show
    @specialty = Specialty.friendly.find(params[:id]) 
    @videos = @specialty.videos
    @user_progress = UserProgress.new(@specialty, current_user)
  end

end
