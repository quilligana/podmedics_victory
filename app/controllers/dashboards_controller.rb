class DashboardsController < ApplicationController
  layout 'user_application'
    
  def show
    @videos = Video.all.limit(10)
  end

end
