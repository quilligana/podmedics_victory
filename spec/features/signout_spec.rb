require 'spec_helper'

feature 'Signing out' do

  let(:admin_user) {FactoryGirl.create(:admin_user,
                                       email: 'admin@example.com',
                                       password: 'password', password_confirmation: 'password')}

  scenario 'Signing out as an admin' do
    sign_in(admin_user)
    click_link 'Logout'
    expect(page).to have_content 'Successfully signed out'
    expect(current_path).to eq root_path
  end
end
