class Permission < Struct.new(:user)

  def allow?(controller, action)
    return true if controller == 'static_pages'
    return true if controller == 'sessions'
    if user
      
      # give admins access to everything
      return true if user.admin?
    end
    false
  end

end
