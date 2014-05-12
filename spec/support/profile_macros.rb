module ProfileMacros

  def update_profile
    fill_in 'user_password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Update Profile'
  end
end
