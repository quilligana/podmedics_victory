require 'spec_helper'

feature 'User Profile' do

  scenario 'Viewing the profile page' do
    user = create(:user, points: 200)
    badge = create(:badge, user: user)
    sign_in(user)
    click_link 'Your Profile'
    expect(page).to have_content user.name
    expect(page).to have_content 'Badges'
    within '.points' do
      expect(page).to have_content 200
    end
    within '.badges' do
      expect(page).to have_content 1
    end
  end

  scenario 'Editing your profile' do
    user = create(:user)
    sign_in(user)
    visit user_path(user)
    click_link 'Edit your profile'
    expect(page).to have_content 'Your Details'

    fill_in 'Name', with: 'A random user name'
    click_button 'Update Profile'

    expect(page).to have_content 'Account details updated'
    within '.profile_header' do
      expect(page).to have_content 'A random user name'
    end
  end

  scenario 'Editing another users profile' do
    another_user = create(:user)
    user = create(:user)
    sign_in(user)
    visit edit_user_path(another_user)
    expect(page).to have_content 'Not authorised'
  end
end
