class DashboardsController < ApplicationController
  layout 'user_application'
    
  def show
    @recent_videos = Video.recent.limit(5).includes(:specialty)
    @flagged_videos = Video.all.limit(10).includes(:specialty)
  end

end
