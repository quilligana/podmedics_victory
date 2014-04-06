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

  scenario "shows the user points total" do
    user = create(:user, points: 4000)
    sign_in(user)
    within '.overall_count_red' do
      expect(page).to have_content user.points
    end
  end

  scenario "shows the user badges count" do
    user = create(:user)
    create(:specialty)
    create(:badge)
    sign_in(user)
    within '.dashboard_count_blocks' do
      expect(page).to have_content user.badges.count
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

  scenario 'Shows recent badges' do
    specialty = create(:specialty)
    user = create(:user)
    badge = create(:badge)
    sign_in(user)
    within '.dashboard_badges_left_column' do
      expect(page).to have_content 'less than a minute ago'
      expect(page).to have_content badge.specialty.name
      expect(page).to have_content badge.level
    end
  end

  scenario 'Shows all badges' do
    specialty = create(:specialty)
    user = create(:user)
    badge = create(:badge)
    sign_in(user)
    within '.dashboard_badges_right_column' do
      expect(page).to have_content badge.specialty.name
      expect(page).to have_content badge.level
    end
  end

  # Helpers
  
  def user_sees_video(video)
    expect(current_path).to eq video_path(video)
  end

end
