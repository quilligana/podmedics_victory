require 'spec_helper'

feature 'User Specialties' do

  scenario 'Viewing a specialty page' do
    specialty = create(:specialty, name: 'Cardiology')
    video = create(:video, specialty: specialty)
    sign_in(create(:user))
    visit video_path(video)
    within '.video_breadcrumb' do
      click_link specialty.name
    end

    expect(page).to have_content specialty.name

    within '.sub_heading_button_set' do
      expect(page).to have_link("Take #{specialty.name.capitalize} Exam", href: specialty_exam_url(specialty.id))
    end

  end
end
