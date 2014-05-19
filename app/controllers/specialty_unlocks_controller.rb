class SpecialtyUnlocksController < ApplicationController

  def create
    @specialty = Specialty.friendly.find(params[:specialty_id])
    unless current_user.has_reached_unlock_limit?
      current_user.unlock_specialty(@specialty)
      redirect_to @specialty, notice: 'Specialty unlocked'
    else
      redirect_to @specialty, alert: 'You have already unlocked two specialties. Please upgrade your subscription.'
    end
  end

end
