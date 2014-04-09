class UsersController < ApplicationController
  layout 'user_application', only: [:show, :edit]

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
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

  def show
    @user = User.find(params[:id])
  end

  def current_resource
    @current_resource || User.find(params[:id]) if params[:id]
  end

  protected

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
