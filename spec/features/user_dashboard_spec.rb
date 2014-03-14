require "spec_helper"

feature 'User dashboard' do

  # this is passing for some reason!!
  scenario "shows name of the logged in user" do
    user = create(:user)
    sign_in(user)
    within '.sub_heading_dashboard_info' do
      expect(page).to have_content user.name
    end
  end

  scenario 'Viewing list of recent videos' do
    video1 = create(:video)
    sign_in(create(:user))
    expect(page).to have_content video1.title
  end

  scenario 'Navigating to video page' do
    video1 = create(:video)
    sign_in(create(:user))
    within '#tabs-1' do
      click_link video1.title
    end
    expect(current_path).to eq video_path(video1)
  end

end
