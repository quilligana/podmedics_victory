class UsersController < ApplicationController
  layout 'user_application', only: [:show, :edit]
  before_action :find_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to plans_path, notice: 'Welcome to Podmedics'
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'Account details updated'
    else
      render :new
    end
  end

  def show
    @badges = current_user.badges
  end

  def current_resource
    @current_resource || User.find(params[:id]) if params[:id]
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

  protected

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
