class SpecialtiesController < ApplicationController
  layout 'user_application'

  def show
    @specialty = Specialty.cached_friendly_find(params[:id]) 
    @videos = @specialty.videos
    @user_progress = UserProgress.new(@specialty, current_user)
    @newQuestion = SpecialtyQuestion.new()
    @notes = @specialty.notes.find_by(user: current_user) || Note.new(noteable: @specialty)
    @top_five = @specialty.get_badges_from_users
  end

end
