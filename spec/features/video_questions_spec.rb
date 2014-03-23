require "spec_helper"

feature 'Video Questions' do

  before(:each) do
    video_specialty = create(:specialty)
    @video = create(:video, specialty: video_specialty)
    @video_2 = create(:video, specialty: video_specialty)
    @question_1 = FactoryGirl.create(:question, video: @video, correct_answer: 2)
    5.times { FactoryGirl.create(:question, video: @video_2, correct_answer: 1) }
    sign_in(create(:user))
  end

  scenario 'Taking the video test' do
    visit video_questions_url(video_id: @video.id)

    within '.lectures_question_title' do
      expect(page).to have_content @question_1.stem
    end

    expect(page).to have_button @question_1.answer_1
    expect(page).to have_button @question_1.answer_2
    expect(page).to have_button @question_1.answer_3
    expect(page).to have_button @question_1.answer_4
    expect(page).to have_button @question_1.answer_5
  end

  scenario 'Answering a question with wrong answer' do
    visit video_questions_url(video_id: @video.id)
    click_button 'First Answer'


    expect(page).to have_content @question_1.explanation
    expect(page).to have_content 'Sorry!'
  end

  scenario 'Answering a question correctly' do
    visit video_questions_url(video_id: @video.id)
    click_button 'Second Answer'

    expect(page).to have_content @question_1.explanation
    expect(page).to have_content 'Congratulations! That is the correct answer.'
  end

  scenario 'Iterating through the questions' do
    visit video_questions_url(video_id: @video_2.id)
    click_button 'First Answer'
    click_button 'Result'
  end

  scenario 'Saving user progress' do
    visit video_questions_url(video_id: @video.id)

    expect do
      click_button 'First Answer'
    end.not_to change(other_user.followers, :count).by(-1)
  end

  # Helpers
  def user_sees_link(link_name)
    expect(page).to have_link link_name
  end
end