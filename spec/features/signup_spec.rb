require "spec_helper"

feature 'Sign up' do

  scenario 'Guest signs up with valid credentials' do
    user_signs_up_with_email('test@example.com')
    expect(page).to have_content 'Welcome to Podmedics'
  end

  scenario 'Guest signs up with no email' do
    user_signs_up_with_email('')
    expect(page).to have_content "can't be blank"
  end

  # Helpers
  def user_signs_up_with_email(email)
    visit root_path
    click_link 'Sign up'
    fill_in 'Email', with: email
    fill_in 'user_password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
  end
end
