require 'spec_helper'

feature 'User Profile' do

  scenario 'Viewing the profile page' do
    user = create(:user)
    sign_in(user)
    click_link 'Your Profile'
    expect(page).to have_content user.name
    expect(page).to have_content 'Badges'
  end

  scenario 'Editing the profile' do
    user = create(:user)
    sign_in(user)
    visit user_path(user)
    click_link 'Edit your profile'
    expect(page).to have_content 'Your Details'
  end

  scenario 'Editing another users profile' do
    another_user = create(:user)
    user = create(:user)
    sign_in(user)
    visit edit_user_path(another_user)
    expect(page).to have_content 'Not authorised'
  end
end
