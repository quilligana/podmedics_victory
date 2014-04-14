require 'spec_helper'

feature 'User Specialties' do

  scenario 'Viewing a specialty page' do
    specialty = create(:specialty, name: 'Cardiology')
    video = create(:video, specialty: specialty)
    user = create(:user)
    sign_in(user)
    visit video_path(video)
    within '.video_breadcrumb' do
      click_link specialty.name
    end

    expect(page).to have_content specialty.name

    within '.sub_heading_button_set' do
      expect(page).to have_link("Take a #{specialty.name.capitalize} Quiz", href: specialty_exam_url(specialty.id))
    end

    within '.lecture_questions_right_column' do
      expect(page).to have_content user.points
      expect(page).to have_content { UserProgress.new(specialty, user).max_specialty_points }
      expect(page).to have_content { UserProgress.new(specialty, user).user_specialty_points }
    end
  end
end
