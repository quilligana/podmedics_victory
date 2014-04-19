class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
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
        store_location
        redirect_to login_path, alert: 'Not authorised'
      end
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
      
      # If no user was found then log the user out since the account they were logged into
      # has been deleted.
      session[:user_id] = nil if @current_user == nil

      return @current_user
    end
    helper_method :current_user

    def get_content
      if current_user
        @categories ||= Category.order(:id).includes(:specialties)
      end
    end

end
