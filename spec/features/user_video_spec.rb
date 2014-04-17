require "spec_helper"

feature 'User Videos' do

  before(:each) do
    video_specialty = create(:specialty)
    @author = create(:author)
    @video = create(:video, specialty: video_specialty, author: @author)
    @video_2 = create(:video, specialty: video_specialty)
    @question = create(:question, video: @video_2)
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
      expect(page).not_to have_link('Answer Questions', href: video_questions_url(@video.id))
    end
  end

  scenario 'Viewing a video which has questions' do
    visit video_path(@video_2)

    within '.video_page_heading_button_set' do
      expect(page).not_to have_link('Answer Questions', href: video_questions_url(@video.id))
    end
  end

  scenario 'Viewing the video author' do
    visit video_path(@video)
    within '.video_page_authour_right_column_user_info' do
      expect(page).to have_content @author.name
      expect(page).to have_content @author.tagline
    end

  end

end
