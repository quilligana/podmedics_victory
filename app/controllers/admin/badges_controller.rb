class Admin::BadgesController < ApplicationController
  layout 'admin_application'

  def index
    @badges = Badge.order(created_at: :desc).paginate(page: params[:page])
  end

end