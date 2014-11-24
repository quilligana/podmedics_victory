class Admin::UsersController < ApplicationController
  layout 'admin_application'
  before_action :set_user, only: [:edit, :update, :show, :destroy, :send_1w_reminder]

  has_scope :has_selected_plan, type: :boolean
  has_scope :expired_before
  has_scope :trial
  has_scope :expired_after

  def index
    @q = User.search(params[:q])
    @users = @q.result.includes(:specialties).order(id: :desc).paginate(page: params[:page])
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

  def remove_if_no_plan
    User.not_selected_plan.destroy_all
    redirect_to admin_users_path, notice: 'Users removed'
  end

  def send_1w_reminder
    UserMailer.delay.one_week_hello(@user)
    @user.update_attributes(reminder_email_received: true)
    redirect_to admin_users_path, notice: 'Reminder sent'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  protected

  def permitted_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin,
                                :selected_plan, :subscribed_on, :expires_on)
  end
end

