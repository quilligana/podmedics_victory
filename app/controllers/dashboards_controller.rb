class DashboardsController < ApplicationController
  layout 'user_application'
    
  def show
    @recent_videos = Video.recent.includes(:specialty).limit(10)
    @flagged_videos = Video.order("views DESC").first(10)
    @badges = current_user.badges.includes(:specialty)
  end

end
