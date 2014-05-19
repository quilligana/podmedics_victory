require 'spec_helper'

feature 'Upgrade Plan' do

  before do
    @user = create(:free_user)
  end

  scenario 'Logging as a free plan member I should see an upgrade link' do
    sign_in(@user)
    expect(current_path).to eq dashboard_path
    expect(page).to have_link 'Upgrade your subscription'
  end

end
