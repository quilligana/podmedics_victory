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

  scenario "shows the user poitns total" do
    user = create(:user, points: 4000)
    sign_in(user)
    within '.overall_count_red' do
      expect(page).to have_content user.points
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
    within '#tabs-3' do
      click_link video1.title
    end
    user_sees_video(video1)
  end

  scenario 'Rewatching a video' do
    video1 = create(:video)
    sign_in(create(:user))
    within '#tabs-3' do
      click_link 'resit_video'
    end
    user_sees_video(video1)
  end

  # Helpers
  
  def user_sees_video(video)
    expect(current_path).to eq video_path(video)
  end

end
