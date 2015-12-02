module SessionsHelper

  def login_user(user)
    session[:user_id] = user.id
    user.mark_plan_selected unless user.plan_selected
    user.record_login
    redirect_for_user(user)
  end

  def redirect_for_user(user)
    if user.admin
      redirect_back_or admin_dashboard_path
    else
      redirect_back_or dashboard_path
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to 
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  private

    def clear_return_to
      session.delete(:return_to)
    end

end
