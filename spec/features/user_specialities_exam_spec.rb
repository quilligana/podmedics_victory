require 'spec_helper'

feature 'User Specialties Exam' do

  before(:each) do
    @specialty = create(:specialty)
    video_1 = create(:video, specialty: @specialty)
    5.times { FactoryGirl.create(:question, video: video_1) }
    @user = create(:user)
    sign_in(@user)
  end

  scenario 'Taking the exam' do
    visit specialty_path(@specialty)
    click_link "Take #{@specialty.name.capitalize} Exam"

    expect(page).to have_content [5, 4, 3, 2, 1]

  end

end