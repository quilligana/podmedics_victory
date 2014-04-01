class Permission < Struct.new(:user)

  def allow?(controller, action)
    return true if controller == 'static_pages'
    return true if controller == 'sessions'
    return true if controller == 'courses'
    return true if controller == 'users' && action == 'new'
    return true if controller == 'users' && action == 'create'
    if user
      return true if controller == 'dashboards'
      return true if controller == 'users' && action == 'show'
      return true if controller == 'videos' && action == 'show'
      return true if controller == 'specialties' && action == 'show'
      return true if controller == 'questions' && action == 'index'
      return true if controller == 'questions' && action == 'specialty_index'
      return true if controller == 'questions' && action == 'show'
      return true if controller == 'questions' && action == 'answer'
      return true if controller == 'questions' && action == 'result'

      return true if user.admin?
    end

    false
  end

end
