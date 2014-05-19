class DashboardsController < ApplicationController
  layout 'user_application'
    
  def show
    @recent_videos = Video.recent.limit(10).includes(:specialty)
    @flagged_videos = Video.flagged(current_user).first(10)
    @badges = current_user.badges
    @percentiles = User.percentile_stat
    @user_percentile = User.percentile
  end

end
