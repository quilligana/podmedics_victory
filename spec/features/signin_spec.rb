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
      expect(current_path).to eq dashboard_path
      user.reload
      expect(user.login_count).to eq 1
      expect(user.last_login_at).to_not be_nil
    end

    scenario 'Non-registered user tries to sign in' do
      bad_details_user = user
      bad_details_user.email = 'george@example.com'
      sign_in(bad_details_user)
      expect(page).to have_content 'Email or password is invalid'
    end

    scenario 'User who has not selected plan signs in' do
      generate_plans
      no_plan_user = create(:no_plan_user)
      sign_in(no_plan_user)
      expect(current_path).to eq show_buy_path(no_plan_user)
    end


    scenario 'Admin user signs in' do
      sign_in(admin_user)
      expect(current_path).to eq admin_dashboard_path
    end

    feature 'Account is deleted after login' do
      before do
        sign_in(user)
        user.destroy

        visit root_url
      end

      scenario 'dashboard should not be viewable' do
        expect(page).to_not have_content 'Dashboard'
      end
    end

    feature 'access requested page after login' do

      scenario 'redirects to correct page' do
        visit edit_user_path(user)
        within '#members_login_form' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_button 'Login'
        end
        expect(current_path).to eq edit_user_path(user)
      end
    end    
  
end
