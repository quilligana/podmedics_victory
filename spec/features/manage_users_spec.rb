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

  scenario 'Adding a user without an email address' do
    sign_in(@admin_user)
    add_user_with_email('', true)
    expect(page).to have_content 'Please review the form'
  end

  scenario 'Editing a user' do
    sign_in(@admin_user)
    update_email_of_user('user2@example.com', @admin_user)
    admin_sees_user_with_email 'user2@example.com'
  end

  scenario 'Editing a user incorrectly' do
    sign_in(@admin_user)
    update_email_of_user('', @admin_user)
    expect(page).to have_content 'Please review the form'
  end

  scenario 'Removing a user' do
    sign_in(@admin_user)
    admin_removes_user(@admin_user)
    admin_sees_no_user_with_email(@admin_user.email)
  end

  # Helpers

  def admin_removes_user(user)
    visit admin_users_path
    within "table tr.user##{user.id}" do
      click_link 'Show'
    end
    click_link 'Remove'
  end

  def admin_sees_no_user_with_email(email)
    expect(page).to_not have_content email
  end

  def add_user_with_email(email, admin=false)
    within '#sidebar-nav' do
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
    click_button 'Create User'
  end

  def admin_sees_user_with_email(email)
    within '.user' do
      expect(page).to have_content email
    end
  end

  def update_email_of_user(email, user)
    within "#user-nav" do
      click_link 'Users'
    end
    within "table tr.user##{user.id}" do
      click_link 'Show'
    end
    click_link 'Edit'
    fill_in 'Email', with: email
    click_button 'Update User'
  end

end
