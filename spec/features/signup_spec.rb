require "spec_helper"

feature 'Sign up', js: true do

  scenario 'Guest signs up with valid credentials' do
    generate_plans
    user_signs_up_with_email('test@example.com')
    expect(current_path).to eq show_buy_path(User.first)

    # Check that the email redirect isn't in effect on regular signups.
    expect(page).to_not have_content 'Please enter a valid email address'
  end

  # intercepted by client side validations
  scenario 'Guest signs up with no email' do
    user_signs_up_with_email('')
    expect(page).to have_content 'A VALID EMAIL IS REQUIRED'
  end

  # intercepted by client side validations
  scenario 'Guest signs up with a bad email address' do
    user_signs_up_with_email('bademail')
    expect(page).to have_content 'A VALID EMAIL IS REQUIRED'
  end

  # Helpers

  def user_signs_up_with_email(email)
    visit root_path
    within '.inner_home_header' do
      click_link 'Sign up now to get started'
    end
    click_link 'Sign up'
    fill_in 'Name', with: 'Test User'
    fill_in 'Email', with: email
    fill_in 'user_password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
  end
end
