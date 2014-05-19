require 'spec_helper'

feature 'User Specialties' do

  before(:each) do
    @specialty = create(:specialty, name: 'Cardiology')
    video = create(:video, specialty: @specialty)
    @user = create(:user)
    question = create(:question, video: video)
    @user_question = create(:user_question, user_id: @user.id, question_id: question.id)
    @vimeo = create(:vimeo, user_id: @user.id, video_id: video.id)
    sign_in(@user)
    visit video_path(video)
    within '.video_breadcrumb' do
      click_link @specialty.name
    end
  end

  scenario 'Viewing a specialty page' do

    expect(page).to have_content @specialty.name

    within '.sub_heading_button_set' do
      expect(page).to have_link("Take the #{@specialty.name.capitalize} Quiz", href: specialty_exam_url(@specialty.id))
    end
  end

  scenario 'Viewing a specialty page with no points' do
    within '.lecture_questions_right_column' do
      expect(page).to have_content @user.points
      expect(page).to have_content { UserProgress.new(@specialty, @user).max_specialty_points }
      expect(page).to have_content { UserProgress.new(@specialty, @user).user_specialty_points }
    end
  end

  scenario 'Viewing a specialty page with some points' do
    @user_question.correct_answer = true
    @vimeo.completed = true
    expect(page).to have_content 10
  end
end
