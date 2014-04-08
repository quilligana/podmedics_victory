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

    def current_resource
      nil
    end

    def authorise
      if !current_permission.allow?(params[:controller], params[:action], current_resource)
        redirect_to login_path, alert: 'Not authorised'
      end
    end

    def current_user
      # The begin/rescue block makes sure that if a user's session is set to an id for a user
      # account that does not exist we log them out and inform them.
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue
        @current_user = nil
        session[:user_id] = nil
        redirect_to login_path, alert: 'This account no longer exists, you have been logged out.'
      end

      return @current_user
    end
    helper_method :current_user

    def get_content
      if current_user
        @categories ||= Category.order(:id).includes(:specialties)
      end
    end

end
