class Admin::DashboardsController < ApplicationController
  layout 'admin_application'
  before_action :authenticate_admin

  def show
  end

end
