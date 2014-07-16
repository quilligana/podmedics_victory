require 'spec_helper'

feature 'User Profile' do

  scenario 'Viewing the profile page' do
    user = create(:user, points: 200)
    badge = create(:badge, user: user)
    user.exams.create(specialty_id: 1, percentage: 90)
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
    update_profile

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
    expect(page).to have_content 'Please login to view this content'
  end

  feature 'Social Media Buttons' do
    before do
      user = create(:user)
      sign_in(user)
      visit user_path(user)
    end

    scenario 'Before linking any accounts' do
        expect(page).to     have_css '.link_facebook_button'
        expect(page).to_not have_css '.linked_facebook_button'

        expect(page).to     have_css '.link_twitter_button'
        expect(page).to_not have_css '.linked_twitter_button'
    end

    scenario 'Linking Twitter' do
      mock_twitter_auth_hash()
      click_link 'Link Twitter*'

      expect(page).to     have_css '.linked_twitter_button'
      expect(page).to_not have_css '.link_twitter_button'
    end

    scenario 'Linking Facebook' do
      mock_facebook_auth_hash()
      click_link 'Link Facebook*'

      expect(page).to     have_css '.linked_facebook_button'
      expect(page).to_not have_css '.link_facebook_button'
    end
  end

  feature 'Custom Domain Button' do
    before do
      user = create(:user)
      sign_in(user)
      visit edit_user_path(user)
    end

    scenario 'Filling in a valid domain' do
      fill_in 'Website', with: 'http://www.example.com'
      update_profile

      expect(page).to have_content 'Website'
      expect(page).to have_css '.website_profile_button'
    end

    scenario 'Filling in an invalid domain' do
      fill_in 'Website', with: 'thisisnotavalidurl'
      update_profile

      expect(page).to have_content 'Website is not a valid URL'
    end
  end

  feature 'Avatars', js: true do
    scenario 'Uploading an image' do
      @user = create(:user)
      sign_in(@user)
      visit edit_user_path(@user)

      default_path = ActionController::Base.helpers.asset_path('avatar-128.jpg')

      expect(page).to have_image(src: default_path)

      click_link 'Change Profile Image'
      attach_file('Avatar', Rails.root.join('spec/fixtures/Avatars/avatar.png'))
      update_profile

      expect(page).to_not have_image(src: default_path)
    end
  end
end
