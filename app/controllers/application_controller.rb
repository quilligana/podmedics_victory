class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorise
  before_action :get_content

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
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue
        session[:user_id] = nil
        redirect_to login_path, alert: 'This account no longer exists, you have been logged out.'
      end
    end
    helper_method :current_user

    def get_content
      if current_user
        @categories = Category.order(:id).includes(:specialties)
      end
    end

end
