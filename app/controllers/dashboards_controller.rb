class DashboardsController < ApplicationController
  layout 'user_application'
    
  def show
    @recent_videos = Video.recent.includes(:specialty).limit(10)
    @flagged_videos = Video.flagged(current_user).first(10)
    @badges = current_user.badges.includes(:specialty)
  end

end
