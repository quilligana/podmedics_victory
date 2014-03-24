require "spec_helper"

feature 'User Videos' do

  before(:each) do
    video_specialty = create(:specialty)
    @video = create(:video, specialty: video_specialty)
    sign_in(create(:user))
  end

  scenario 'Viewing a video and meta information' do
    visit video_path(@video)
    
    within '.video_page_heading_wrapper' do
      expect(page).to have_link @video.title
      expect(page).to have_link @video.specialty_name
    end

    within '.video_page_author_duration_header' do
      expect(page).to have_content @video.description
    end

    within '.video_page_heading_button_set' do
      expect(page).to have_link('Answer Questions', href: video_questions_url(@video.id))
    end
  end

end
