class DashboardsController < ApplicationController
  layout 'user_application'
    
  def show
    @recent_videos = Video.recent.limit(10).includes(:specialty)
    @flagged_videos = Video.flagged(current_user).first(10)
    @badges = current_user.badges
    @recent_questions = SpecialtyQuestion.recent(3) 
    #@percentiles = User.percentile_stat
    #@user_percentile = current_user.percentile
  end

end
