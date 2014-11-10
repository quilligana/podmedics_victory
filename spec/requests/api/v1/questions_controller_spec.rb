require 'spec_helper'

describe "Questions API" do

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

  it "retrieves 1 question from 10 specialties" do
    # FactoryGirl.create_list(:message, 10)

    get 'api/v1/questions/sample'

    expect(response).to be_success
    # json = JSON.parse(response.body)
    # expect(json['messages'].length).to eq(10)
  end

end