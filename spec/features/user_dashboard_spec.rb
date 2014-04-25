require "spec_helper"

feature 'User dashboard' do

  before(:each) do
    @specialty = create(:specialty)
    @video1 = create(:video, specialty: @specialty)
    @user = create(:user, points: 400)
    sign_in(@user)
  end

  scenario "shows name of the logged in user" do
    within '.sub_heading_dashboard_info' do
      expect(page).to have_content @user.name
    end
  end

  scenario "shows the user points total" do
    within '.overall_count_red' do
      expect(page).to have_content @user.points
    end
  end

  scenario "shows the user badges count" do
    create(:badge, user: @user)
    visit dashboard_path
    within '.dashboard_count_blocks' do
      expect(page).to have_content @user.badges.count
    end
  end

  scenario 'Viewing list of recent videos' do
    expect(page).to have_content @video1.title
  end

  scenario 'Navigating to video page' do
    within '#tabs-3' do
      click_link @video1.title
    end
    user_sees_video(@video1)
  end

  scenario 'Shows recent badges' do
    badge = create(:badge, user: @user, specialty: @specialty)
    visit root_path
    within '.dashboard_badges_left_column' do
      expect(page).to have_content 'less than a minute ago'
      expect(page).to have_content badge.specialty.name
      expect(page).to have_content badge.level
    end
  end

  scenario 'Shows all badges' do
    badge = create(:badge, user: @user, specialty: @specialty)
    visit root_path
    within '.dashboard_badges_right_column' do
      expect(page).to have_content badge.specialty.name
      expect(page).to have_content badge.level
    end
  end

  scenario 'Having watched a video' do
    create(:vimeo, user_id: @user.id, video_id: @video1.id, completed: true)
    visit root_path
    within '#tabs-2 .lecture_icons_wrapper' do
      expect(page).to have_css(".lecture_icon.watched")
      expect(page).to have_css(".lecture_icon.resit")
      expect(page).not_to have_css(".lecture_icon.part_watched")
      expect(page).not_to have_css(".lecture_icon.not_watched")
      expect(page).not_to have_css(".lecture_icon.recommended_resit")
      expect(page).not_to have_css(".lecture_icon.top_marks")
    end
  end

  scenario 'Having part-watched a video' do
    create(:vimeo, user_id: @user.id, video_id: @video1.id)
    visit root_path
    within '#tabs-2 .lecture_icons_wrapper' do
      expect(page).to have_css(".lecture_icon.part_watched")
      expect(page).not_to have_css(".lecture_icon.watched")
      expect(page).not_to have_css(".lecture_icon.not_watched")
      expect(page).not_to have_css(".lecture_icon.recommended_resit")
      expect(page).not_to have_css(".lecture_icon.resit")
      expect(page).not_to have_css(".lecture_icon.top_marks")
    end
  end

  scenario 'Having not watched a video' do
    within '#tabs-2 .lecture_icons_wrapper' do
      expect(page).to have_css(".lecture_icon.not_watched")
      expect(page).not_to have_css(".lecture_icon.part_watched")
      expect(page).not_to have_css(".lecture_icon.watched")
      expect(page).not_to have_css(".lecture_icon.recommended_resit")
      expect(page).not_to have_css(".lecture_icon.resit")
      expect(page).not_to have_css(".lecture_icon.top_marks")
    end
  end

  scenario 'Having had a poor score' do
    create(:vimeo, user_id: @user.id, video_id: @video1.id, completed: true)
    question = create(:question, video: @video1)
    create(:user_question, user_id: @user.id, question_id: question.id, correct_answer: false)
    visit root_path
    within '#tabs-2' do
      expect(page).to have_css(".lecture_icon.recommend_resit")
      expect(page).to have_css(".lecture_icon.watched")
      expect(page).to have_css(".lecture_icon.resit")
      expect(page).not_to have_css(".lecture_icon.part_watched")
      expect(page).not_to have_css(".lecture_icon.recommended_resit")
      expect(page).not_to have_css(".lecture_icon.top_marks")
    end
  end

  scenario 'Having achieved top marks' do
    create(:vimeo, user_id: @user.id, video_id: @video1.id, completed: true)
    question = create(:question, video: @video1)
    create(:user_question, user_id: @user.id, question_id: question.id, correct_answer: true)
    visit root_path
    within '#tabs-2' do
      expect(page).to have_css(".lecture_icon.top_marks")
      expect(page).to have_css(".lecture_icon.watched")
      expect(page).to have_css(".lecture_icon.resit")
      expect(page).not_to have_css(".lecture_icon.part_watched")
      expect(page).not_to have_css(".lecture_icon.recommended_resit")
    end
  end

  # Helpers
  
  def user_sees_video(video)
    expect(current_path).to eq video_path(video)
  end

end
