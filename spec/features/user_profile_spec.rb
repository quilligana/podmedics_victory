require 'spec_helper'

feature 'User Profile' do

  scenario 'Viewing the profile page' do
    user = create(:user)
    sign_in(user)
    click_link 'Your Profile'
    expect(page).to have_content user.name
    expect(page).to have_content 'Badges'
  end
end
