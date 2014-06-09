class SessionsController < ApplicationController

  def new
    if current_user
      redirect_to dashboard_path
    end
  end

  def create
    auth_hash = env["omniauth.auth"]
    auth = Authentication.new(params, auth_hash)

    if current_user
      current_user.link_social_url(auth_hash)
      current_user.save
      redirect_to current_user
    elsif auth.authenticated?
      login_user(auth.user)
    else
      flash.now.alert = auth.error_message
      render :new
    end
  end

  def oauth_failure
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Successfully signed out'
  end
  
end
