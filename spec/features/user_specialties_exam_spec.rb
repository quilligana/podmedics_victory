require 'spec_helper'

feature 'User Specialties Exam' do

  before(:each) do
    @specialty_1 = create(:specialty)
    video_1 = create(:video, specialty: @specialty_1)
    10.times { FactoryGirl.create(:question, video: video_1) }
    video_2 = create(:video, specialty: @specialty_1)
    12.times { FactoryGirl.create(:question, video: video_2) }
    video_3 = create(:video, specialty: @specialty_1)
    14.times { FactoryGirl.create(:question, video: video_3) }
    @user = create(:user)
    sign_in(@user)
  end

  scenario 'Taking the exam' do
    visit specialty_path(@specialty_1)

    click_link "Take the #{@specialty_1.name.capitalize} Quiz"

    expect(page).to have_content "This is stem number"
    expect(page).to have_button "First Answer"
    expect(page).to have_button "Second Answer"
    expect(page).to have_button "Third Answer"
    expect(page).to have_button "Fourth Answer"
    expect(page).to have_button "Fifth Answer"
  end

  scenario 'Registering user_questions when initailly clicking take-exam' do
    visit specialty_path(@specialty_1)

    expect do
      click_link "Take the #{@specialty_1.name.capitalize} Quiz"
    end.to change(UserQuestion, :count).by(30)
  end

  scenario 'Return to Specialties page on completion of the exam' do
    visit specialty_path(@specialty_1)
    click_link "Take the #{@specialty_1.name.capitalize} Quiz"

    29.times do
      click_button "Second Answer"
      click_link "Next Question"
    end
    click_button "Second Answer"
    click_link "Result"

    expect(page).to have_link("Back to Specialty", href: specialty_path(@specialty_1))
    expect(page).to have_content("Congratulations! You have passed the #{@specialty_1.name} exam.")
  end

  scenario 'Show failure notification if user fails an exam' do
    visit specialty_path(@specialty_1)
    click_link "Take the #{@specialty_1.name.capitalize} Quiz"

    29.times do
      click_button "First Answer"
      click_link "Next Question"
    end
    click_button "Second Answer"
    click_link "Result"

    expect(page).to have_link("Back to Specialty", href: specialty_path(@specialty_1))
    expect(page).to have_content("We are sorry but you have not passed the #{@specialty_1.name} exam.")
  end

  scenario 'No questions from the wrong specialty should be served' do
    specialty_2 = create(:specialty)
    video_4 = create(:video, specialty: specialty_2)
    test_question = create(:question, video: video_4)
    specialty_3 = create(:specialty)
    video_5 = create(:video, specialty: specialty_3)
    non_test_question = create(:question, video: video_5)

    visit specialty_path(specialty_2)
    click_link "Take the #{specialty_2.name.capitalize} Quiz"

    expect(page).not_to have_content non_test_question.stem
    click_button "Second Answer"
    expect(page).to have_link "Result"
  end

end
