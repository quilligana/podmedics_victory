class Permission < Struct.new(:user)

  def allow?(controller, action)
    return true if controller == 'static_pages'
    return true if controller == 'sessions'
    return true if controller == 'users' && action == 'new'
    return true if controller == 'users' && action == 'create'
    if user
      return true if controller == 'dashboards'

      return true if user.admin?
    end

    false
  end

end