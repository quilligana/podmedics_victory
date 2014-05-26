require 'spec_helper'

feature 'Password Resets' do

  scenario 'emailing user when requests password reset' do
    user = create(:user)
    visit login_path
    within '#members_reset_password_form' do
      fill_in 'Email', with: user.email
      click_button 'Reset Password'
    end
    expect(current_path).to eq root_path
    expect(page).to have_content 'Email sent'
    expect(last_email.to).to include(user.email)
  end

  scenario 'Showing an error message when no email is found' do
    visit login_path
    within '#members_reset_password_form' do
      fill_in 'Email', with: 'fake_email@example.com' 
      click_button 'Reset Password'
    end
    expect(current_path).to eq login_path
    expect(page).to have_content 'Sorry we could not find that email address. Did you register with a different one?'

  end
end
