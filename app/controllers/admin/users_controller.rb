class Admin::UsersController < ApplicationController
  layout 'admin_application'
  before_action :set_user, only: [:edit, :update, :show, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update(permitted_params)
      redirect_to admin_user_path(@user), notice: 'User updated'
    else
      flash.now.alert = 'Please review the form'
      render :edit
    end
  end

  def show
  end

  def create
    @user = User.create(permitted_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: 'User added'
    else
      flash.now.alert = 'Please review the form'
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User removed'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  protected

  def permitted_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin,
                                :selected_plan)
  end
end

