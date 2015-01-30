class SpecialtyUnlocksController < ApplicationController

  def create
    @specialty = Specialty.friendly.find(params[:specialty_id])
    unless current_user.has_reached_unlock_limit?
      if current_user.has_access_to?(@specialty)
        redirect_to @specialty, notice: 'You have already unlocked this specialty'
      else
        current_user.unlock_specialty(@specialty)
        redirect_to @specialty, notice: 'Specialty unlocked'
      end
    else
      redirect_to @specialty, alert: 'You have already unlocked two specialties. Please upgrade your subscription to unlock more.'
    end
  end

end
