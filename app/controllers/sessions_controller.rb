class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      login_for_user(user)
    else
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully signed out'
  end

  private

  def login_for_user(user)
    if user.admin
      redirect_to admin_dashboard_path, notice: 'Welcome to Podmedics Admin'
    else
      redirect_to dashboard_path, notice: 'Welcome to Podmedics'
    end
  end

end
