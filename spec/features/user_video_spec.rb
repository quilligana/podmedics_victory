require "spec_helper"

feature 'User Videos' do

  scenario 'Viewing a video and meta information' do
    video_specialty = create(:specialty)
    video = create(:video, specialty: video_specialty)
    sign_in(create(:user))
    visit video_path(video)
    
    within '.video_page_heading_wrapper' do
      expect(page).to have_link video.title
      expect(page).to have_link video.specialty_name
    end

    within '.video_page_author_duration_header' do
      expect(page).to have_content video.description
    end
  end

end
