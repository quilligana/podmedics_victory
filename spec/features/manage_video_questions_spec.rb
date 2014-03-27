require 'spec_helper'

feature 'Manage video questions' do
  scenario 'Adding a new question for a video' do
    video = create(:video)
    admin = create(:admin_user)
    sign_in(admin)
    add_question_for_video(video)
    admin_sees_question_info(video.questions.first)
  end

  scenario 'Editing a question for a video' do
    video = create(:video)
    admin = create(:admin_user)
    sign_in(admin)
    add_question_for_video(video)
    within '.questions' do
      click_link 'Edit'
    end
    fill_in 'Stem', with: 'What is the smallest organ in the body?'
    click_button 'Submit'
    expect(page).to have_content 'What is the smallest organ in the body?'
  end

  def add_question_for_video(video)
    visit admin_video_path(video)
    click_link 'Add question'
    fill_in 'Stem', with: 'What is the largest organ in the body?'
    fill_in 'Answer 1', with: 'Heart'
    fill_in 'Answer 2', with: 'Lungs'
    fill_in 'Answer 3', with: 'Liver'
    fill_in 'Answer 4', with: 'Kidney'
    fill_in 'Answer 5', with: 'Skin'
    fill_in 'Correct Answer', with: 5
    fill_in 'Explanation', with: 'The skin is the largest organ - stupid!'
    click_button 'Submit'
  end

  # Helpers
  def admin_sees_question_info(question)
    expect(current_path).to eq admin_video_path(question.video)
    expect(page).to have_content question.stem
  end

end
