class DashboardsController < ApplicationController
  layout 'user_application'
    
  def show
    @recent_videos = Video.recent.limit(10)
    @flagged_videos = Video.flagged(current_user).first(10)
    @badges = current_user.badges.includes(:specialty)
    @recent_questions = SpecialtyQuestion.includes(:specialty, :user).recent(3) 
    #@percentiles = User.percentile_stat
    #@user_percentile = current_user.percentile
  end

end
