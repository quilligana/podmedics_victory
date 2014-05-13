class UsersController < ApplicationController
  layout 'user_application', only: [:show, :edit, :update, :email]
  before_action :find_user, only: [:show, :edit, :update, :email]

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user(@user)
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'Account details updated'
    else
      render :edit
    end
  end

  def show
    @badges = current_user.badges
  end

  def current_resource
    @current_resource || User.cached_find(params[:id]) if params[:id]
  end

  def email
    unless @user.email.blank?
      redirect_to dashboard_path
    end
  end

  private

    def find_user
      @user = User.cached_find(params[:id])
      if @user.nil?
        redirect_to dashboard_path
      end
    end

  protected

    def user_params
      params.require(:user).permit(:name, :email, :website, :avatar, :password, :password_confirmation)
    end

end
