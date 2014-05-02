require 'spec_helper'

feature 'Video Tags' do

  before do
    @video = create(:video, tag_list: 'angina, chest pain')
    sign_in(create(:user))
  end

  scenario "Viewing tags on a video page" do
    visit video_path(@video)
    within '.video_page_tags_wrapper' do
      expect(page).to have_link 'angina'
      expect(page).to have_link 'chest pain'
    end
  end

  scenario 'Clicking on a tag on the video page' do
    another_tagged_video = create(:video, title: 'ACS', tag_list: 'angina')
    no_tag_video = create(:video, title: 'Hip Fracture')
    visit video_path(@video)
    within '.video_page_tags_wrapper' do
      click_link 'angina'
    end
    expect(current_path).to eq tag_path('angina')
    expect(page).to have_content @video.title
    expect(page).to have_content another_tagged_video.title
    expect(page).to_not have_content no_tag_video.title
  end

end
