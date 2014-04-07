require 'spec_helper'

feature 'Login' do

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
      expect(current_path).to eq admin_dashboard_path
    end

    # TODO: not sure why this is failing with permission class refactor
    #feature 'Account is deleted after login' do
      #before do
        #sign_in(user)
        #user.destroy

        #visit root_url
      #end

      #scenario 'should inform user that account has been deleted' do
        #expect(page).to have_content 'This account no longer exists, you have been logged out.'
      #end

      #scenario 'dashboard should not be viewable' do
        #expect(page).to_not have_content 'Dashboard'
      #end
    #end
end
