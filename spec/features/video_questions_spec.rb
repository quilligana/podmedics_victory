require "spec_helper"

feature 'Video Questions' do

  before(:each) do
    @video_specialty = create(:specialty)
    @video = create(:video, specialty: @video_specialty)
    @user = create(:user)
    sign_in(@user)
  end

  scenario 'Registering user_questions when initailly clicking answer-questions' do
    visit video_path(@video)

    expect do
      click_link 'Answer Questions'
    end.to change(UserQuestion, :count).by(1)
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

  before do
    @video_2 = create(:video, specialty: @video_specialty)
    @question_1 = FactoryGirl.create(:question, video: @video)
    5.times { FactoryGirl.create(:question, video: @video_2) }
  end

  scenario 'Iterating through the questions' do

    visit video_questions_url(video_id: @video_2.id)

    click_button 'First Answer'
    click_link 'Next Question'
    click_button 'First Answer'
    click_link 'Next Question'
    click_button 'First Answer'
    click_link 'Next Question'
    click_button 'First Answer'
    click_link 'Next Question'
    click_button 'First Answer'

    click_link 'Result'

    within '.questions_result_title' do
      click_link 'Back to Video'
    end

    expect(page).to have_content @video_2.title 

  end

  before do
    @video_3 = create(:video, specialty: @video_specialty)
    @first_question = create(:question, video: @video_3)
    5.times { FactoryGirl.create(:question, video: @video_3) }
  end

  scenario 'Not saving user progress for incorrect answers' do
    visit video_questions_url(video_id: @video_3.id)

    expect do
      click_button 'First Answer'
    end.not_to change { user_question_object }.from(false).to(true)

  end
 
  scenario 'Saving user progress when correct answer is given' do
   visit video_questions_url(video_id: @video_3.id)

    expect do
      click_button 'Second Answer'
    end.to change { user_question_object }.from(false).to(true)
  end

  # Helpers
  def user_sees_link(link_name)
    expect(page).to have_link link_name
  end

  def user_question_object
    UserQuestion.where(user_id: @user.id).where(question_id: @video_3.question_ids.first).first.correct_answer
  end
end
