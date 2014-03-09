require "spec_helper"

feature 'User Navigation' do

  before :each do
    sign_in(create(:user))
  end

  scenario 'sees logout link' do
    user_sees_link 'Logout'
  end

  scenario 'sees profile link' do
    user_sees_link 'Your Profile'
  end

  scenario 'sees courses link' do
    user_sees_link 'Courses'
  end

  scenario 'sees lectures link' do
    user_sees_link 'Lectures'
  end

  scenario 'sees support link' do
    user_sees_link 'Support'
  end

  # Helpers
  def user_sees_link(link_name)
    expect(page).to have_link link_name
  end
end
