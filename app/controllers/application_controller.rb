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
        redirect_to login_path, alert: 'Not authorised'
      else
        # Make sure the user is logged in
        if current_user
          # Check whether the user has a set email. If not, redirect them to the edit user page and
          # request an email address.
          # The only situation this comes up in is if the user has signed up with twitter.
          if current_user.email.blank?
            # Only redirect if they aren't already on the page to enter an email address.
            unless params[:controller] == 'users'
              redirect_to edit_user_path(current_user.id), notice: 'Please enter a valid email address'
            end
          else
            # Check whether the user has chosen a plan. If not, redirect them to the plan page.
            unless current_user.has_selected_plan?
              # Only redirect if they aren't already selecting a plan.
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
