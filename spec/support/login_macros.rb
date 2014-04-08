module LoginMacros

  def sign_in(user)
    visit login_path
    within '#members_login_form' do
      fill_in 'email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end
  end

  def set_session_for(user)
    session[:user_id] = user.id
  end

  def log_out(user)
    within '.inner_menu_wrapper' do
      click_link 'Logout'
    end
  end

end
