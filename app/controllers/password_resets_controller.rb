class PasswordResetsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      redirect_to root_url, notice: 'Email sent with password reset instructions. Due to current traffic on the site it may take an hour or two to come through.'
    else
      redirect_to login_path, alert: 'Sorry we could not find that email address. Did you register with a different one?'
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 6.hours.ago
      redirect_to login_path, alert: 'Password reset has expired.'
    elsif @user.update_attributes(user_params)
      login_user(@user)
    else
      render :edit
    end
  end

  protected

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

end
