require "spec_helper"

feature 'User Badges' do

  before(:each) do
    @specialty = create(:specialty)
    @video = create(:video, specialty: @specialty)
    10.times { FactoryGirl.create(:question, video: @video) }
    @user = create(:user)
    @user_2 = create(:user)
    @vimeo = create(:vimeo, user_id: @user.id, video_id: @video.id)
    sign_in(@user)
  end

  scenario 'before achieving any badges' do
    visit video_path(@video)
    click_link 'Answer Questions'

    expect(@user.badges.first).to be_nil
  end

  scenario 'achieving a first badge' do
    visit video_path(@video)
    click_link 'Answer Questions'

    5.times do
      click_button 'Second Answer'
      click_link "Next Question"
    end
    click_button 'Second Answer'

    expect(page).to have_content 'Congratulations! You have just been awarded a new badge'
    expect(page).to have_content 'Medical Student'
    Delayed::Job.last.handler.should have_content @user.email
    #last_email.to.should include(@user.email)
  end

  scenario 'achieving a second badge' do
    visit video_path(@video)
    click_link 'Answer Questions'

    5.times do
      click_button 'Second Answer'
      click_link "Next Question"
    end
    click_button 'Second Answer'

    expect(page).to have_content 'Congratulations! You have just been awarded a new badge'
    expect(page).to have_content 'House Officer'
    Delayed::Job.last.handler.should have_content @user.email
    #last_email.to.should include(@user.email)
  end

  scenario 'achieving a professor badge without an existing professor' do
    @vimeo.update_attributes(completed: true)
    visit video_path(@video)
    click_link 'Answer Questions'

    9.times do
      click_button 'Second Answer'
      click_link 'Next Question'
    end
    click_button 'Second Answer'

    expect(page).to have_content 'Congratulations! You have just been awarded a new badge'
    expect(page).to have_content 'Professor'
    Delayed::Job.last.handler.should have_content @user.email
    #last_email.to.should include(@user.email)
  end

  # scenario 'achieving a professor badge with an existing professor' do
  #   @specialty.update_attributes(professor: @user_2.id)
  #   @vimeo.update_attributes(completed: true)
  #   visit video_path(@video)
  #   click_link 'Answer Questions'

  #   9.times do
  #     click_button 'Second Answer'
  #     click_link 'Next Question'
  #   end
  #   click_button 'Second Answer'

  #   expect(page).to have_content 'Congratulations! You have just been awarded a new badge'
  #   expect(page).to have_content 'Professor'
  #   last_email.to.should include(@user.email)
  #   second_last_email.to.should include
  # end

end
