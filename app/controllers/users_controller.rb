class UsersController < ApplicationController
  layout 'user_application', only: [:show, :edit, :update, :email]
  before_action :find_user, only: [:show, :edit, :update, :email, :destroy, :move_to_gravatar]

  def new
    @user = User.new
    @paid_6 = Product.where(permalink: 'paid6').first
    @paid_12 = Product.where(permalink: 'paid12').first
  end

  def edit
  end

  def create
    @paid_6 = Product.where(permalink: 'paid6').first
    @paid_12 = Product.where(permalink: 'paid12').first
    @user = User.new(user_params)
    # for making podmedics free
    @user.mark_plan_selected
    if @user.save
      login_user(@user)
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      if user_params[:avatar]
        notice = 'Your avatar is being processed'
      else
        notice = 'Account details updated'
      end
      redirect_to @user, notice: notice
    else
      render :edit
    end
  end

  def show
    @badges = current_user.badges.includes(:specialty)
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Thank you for using Podmedics. Your account has been removed.'
  end

  def current_resource
    @current_resource || User.cached_find(params[:id]) if params[:id]
  end

  def email
    redirect_to dashboard_path unless @user.email.blank?
  end

  def move_to_gravatar
    if @user.remove_gravatar
      redirect_to "https://en.gravatar.com/"
    else
      render :edit
    end
  end

  def unsubscribed
    @unsubscribe = Unsubscribe.new(params)
    @unsubscribe.unsubscribe
    flash.now.alert = @unsubscribe.notice
  end

  def unsubscribe
    @unsubscribe = Unsubscribe.new(params)
    unless @unsubscribe.user
      flash.now.alert = 'Sorry. Your account was not found.'
    end
  end

  private

    def find_user
      @user = User.cached_find(params[:id])
      redirect_to dashboard_path if @user.nil?
    end

  protected

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :website,
        :avatar,
        :password,
        :password_confirmation,
        :receive_newsletters,
        :receive_reply_notifications,
        :receive_status_updates,
        :receive_new_episode_notifications,
        :receive_social_notifications,
        :receive_help_request_notifications
        )
    end

end
