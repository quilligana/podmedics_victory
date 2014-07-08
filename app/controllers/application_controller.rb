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
      unless current_permission.allow?(params[:controller], params[:action], current_resource)
        store_location
        redirect_to login_path, alert: 'Please login to review this content'
      else
        if current_user
          if current_user.email.blank?
            unless params[:controller] == 'users'
              redirect_to email_user_path(current_user.id), notice: 'Please enter a valid email address'
            end
          else
            unless current_user.has_selected_plan?
              unless params[:controller] == 'transactions'
                redirect_to show_buy_path(current_user.id), notice: 'Please select a plan before proceeding'
              end
            end
          end
        end
      end
    end

    def current_user
      @current_user ||= User.cached_find(session[:user_id]) if session[:user_id]
      session[:user_id] = nil if @current_user == nil

      return @current_user
    end
    helper_method :current_user

    def logout
      @current_user = nil
      session[:user_id] = nil
    end

    def get_content
      if current_user
        @categories ||= Category.includes(:specialties).order(:id)
      end
    end

end
