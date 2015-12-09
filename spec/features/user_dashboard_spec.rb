require "spec_helper"

feature 'User dashboard' do

  before(:each) do
    @specialty = create(:specialty)
    @video1 = create(:video, specialty: @specialty)
    @user = create(:user, points: 400)
    sign_in(@user)
  end

  scenario "Visiting the dashboard page" do
    within '.recent_videos' do
      expect(page).to have_content @video1.title
    end
  end

  scenario "seeing the correct stats" do
    create(:badge, user: @user)
    video2 = create(:video, title: "I'm a doctor")
    create(:vimeo, user_id: @user.id, video_id: @video1.id, completed: true)
    create(:vimeo, user_id: @user.id, video_id: video2.id, completed: true)
    @user.exams.create(specialty_id: @specialty.id, percentage: 90)
    @user.reload
    visit root_path

    within '.overall_count_red' do
      expect(page).to have_content @user.points
    end

    within '.watched_videos' do
      expect(page).to have_content watched_videos
    end

    within '.badges_count' do
      expect(page).to have_content @user.badges.count
    end
  end

  scenario 'Navigating to video page' do
    within '.recent_videos' do
      click_link @video1.title
    end
    user_sees_video(@video1)
  end

  scenario 'Having watched a video' do
    create(:vimeo, user_id: @user.id, video_id: @video1.id, completed: true)
    visit root_path
    within '.flagged_videos' do
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
    within '.flagged_videos' do
      expect(page).to have_css(".lecture_icon.part_watched")
      expect(page).not_to have_css(".lecture_icon.watched")
      expect(page).not_to have_css(".lecture_icon.not_watched")
      expect(page).not_to have_css(".lecture_icon.recommended_resit")
      expect(page).not_to have_css(".lecture_icon.resit")
      expect(page).not_to have_css(".lecture_icon.top_marks")
    end
  end

  scenario 'Having not watched a video' do
    within '.flagged_videos' do
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
    within '.flagged_videos' do
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
    within '.flagged_videos' do
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

  def watched_videos
    @user.vimeos.where(completed: true).count
  end

  def exam_passes
    @user.exams.where("percentage > ?", PASS_GRADE).count
  end

end
