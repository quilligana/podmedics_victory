class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'Welcome to Podmedics'
    else
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

end
