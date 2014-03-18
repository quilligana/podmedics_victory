require 'spec_helper'

feature 'Manage users' do

  background do
    @admin_user = create(:admin_user)
  end

  scenario  'Adding a new user' do
    sign_in(@admin_user)
    add_user_with_email 'user@example.com'
    admin_sees_user_with_email 'user@example.com'
  end

  scenario 'Adding an admin user' do
    sign_in(@admin_user)
    add_user_with_email('admin@example.com', true)
    admin_sees_user_with_email 'admin@example.com'
    expect(User.where(admin: true).count).to eq 2
  end

  scenario 'Editing a user' do
    user = create(:user)
    sign_in(@admin_user)
    update_email_of_user('user2@example.com', user)
    admin_sees_user_with_email 'user2@example.com'
  end

  scenario 'Removing a user' do
    user = create(:user)
    sign_in(@admin_user)
    admin_removes_user(user)
    admin_sees_no_user_with_email(user.email)
  end

  # Helpers

  def admin_removes_user(user)
    visit admin_users_path
    within "table tr.user##{user.id}" do
      click_link 'Remove'
    end
  end

  def admin_sees_no_user_with_email(email)
    expect(page).to_not have_content email
  end

  def add_user_with_email(email, admin=false)
    within '.sidebar' do
      click_link 'Users'
    end
    click_link 'New User'
    fill_in 'Name', with: 'Test'
    fill_in 'Email', with: email
    fill_in 'user_password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    if admin
      check 'Admin'
    end
    click_button 'Submit'
  end

  def admin_sees_user_with_email(email)
    within '.user' do
      expect(page).to have_content email
    end
  end

  def update_email_of_user(email, user)
    click_link 'Users'
    within "table tr.user##{user.id}" do
      click_link 'Edit'
    end
    fill_in 'Email', with: email
    click_button 'Submit'
    
  end

end
