class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      login_user(user)
    else
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def omniauthcreate
    auth = env["omniauth.auth"]

    if current_user
      current_user.link_social_url(auth)
      redirect_to current_user
    else
      if User.exists?(email: auth.info.email)
        redirect_to login_path, notice: "There is already a Podmedics account registered to #{auth.info.email}"
      else
        user = User.from_omniauth(auth)
        login_user(user)
      end
    end
  end

  def oauth_failure
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully signed out'
  end
  
end
