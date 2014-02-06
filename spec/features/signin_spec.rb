require 'spec_helper'

feature 'Sign in' do

    let(:user) {FactoryGirl.create(:user,
                                   email: 'test@example.com',
                                   password: 'password', password_confirmation: 'password')}
    let(:admin_user) {FactoryGirl.create(:admin_user,
                                   email: 'admin@example.com',
                                   password: 'password', password_confirmation: 'password')}

    scenario 'Registered user signs in' do
      sign_in(user)
      expect(page).to have_content 'Welcome to Podmedics'
    end

    scenario 'Non-registered user tries to sign in' do
      bad_details_user = user
      bad_details_user.email = 'george@example.com'
      sign_in(bad_details_user)
      expect(page).to have_content 'Email or password is invalid'
    end


    scenario 'Admin user signs in' do
      sign_in(admin_user)
      expect(page).to have_content 'Welcome to Podmedics Admin'
    end

end