class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorise

  delegate :allow?, to: :current_permission
  helper_method :allow?

  private

    def current_permission
      @current_permission ||= Permission.new(current_user)
    end

    def authorise
      unless current_permission.allow?(params[:controller], params[:action])
        redirect_to login_path, alert: 'Not authorised'
      end
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

end
