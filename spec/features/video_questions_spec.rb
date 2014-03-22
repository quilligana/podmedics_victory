require "spec_helper"

feature 'Video Questions' do

  before(:each) do
    video_specialty = create(:specialty)
    @video = create(:video, specialty: video_specialty)
    sign_in(create(:user))
  end

  scenario 'Taking the video test' do
    visit video_questions_url(@video)

    user_sees_link 'ACE-inhibitor'
    user_sees_link 'Beta-blocker'
    user_sees_link 'Diuretic'
    user_sees_link 'Calcium channel blocker'
    user_sees_link 'Spironolactone'
  end

  scenario 'Answering a question with wrong answer' do
    visit video_questions_url(@video)
    click_link 'ACE-inhibitor'

    expect(page).to have_content 'Incorrect'
    user_sees_link 'Next Question'
  end

  scenario 'Answering a question correctly' do
    visit video_questions_url(@video)
    click_link 'Calcium channel blocker'

    expect(page).to have_content 'Correct'
    user_sees_link 'Next Question'
  end

  # Helpers
  def user_sees_link(link_name)
    expect(page).to have_link link_name
  end
end