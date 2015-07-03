require "spec_helper"

feature 'User Navigation' do

  before :each do
    sign_in(create(:user))
  end

  scenario 'sees home link' do
    user_sees_link 'Home'
  end

  scenario 'sees lectures link' do
    user_sees_link 'Lectures'
  end

  scenario 'sees notes link' do
    user_sees_link 'Notes'
  end

  scenario 'sees profile link' do
    user_sees_link 'Your Profile'
  end

  scenario 'sees blog link' do
    user_sees_link 'Blog'
  end

  scenario 'sees support link' do
    user_sees_link 'Support'
  end

  scenario 'sees logout link' do
    user_sees_link 'Logout'
  end

  # Helpers
  def user_sees_link(link_name)
    expect(page).to have_link link_name
  end
end
