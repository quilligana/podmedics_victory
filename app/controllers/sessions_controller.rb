class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if user.has_selected_plan?
        session[:user_id] = user.id
        login_for_user(user)
      else
        redirect_to show_buy_path(user.id), notice: 'Please select a plan before proceeding'
      end
    else
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def omniauthcreate
    auth = env["omniauth.auth"]

    # If the user is already logged in
    # link the omniauth account
    if current_user
      current_user.link_social_url(auth)
      redirect_to current_user
    else
      user = User.from_omniauth(auth)
      session[:user_id] = user.id
      login_for_user(user)
    end
  end

  def oauth_failure
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully signed out'
  end

  def login_for_user(user)
    user.record_login
    if user.admin
      redirect_back_or admin_dashboard_path
    else
      redirect_back_or dashboard_path
    end
  end

end
