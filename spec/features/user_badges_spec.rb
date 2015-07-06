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


end
