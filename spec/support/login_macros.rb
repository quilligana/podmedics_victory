module LoginMacros

  def sign_in(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end

  def set_session_for(user)
    session[:user_id] = user.id
  end

end
