class Admin::BadgesController < ApplicationController
  layout 'admin_application'

  def index
    @badges = Badge.includes(:user, :specialty).order(id: :desc).paginate(page: params[:page])
  end

end
