require 'spec_helper'

describe "Questions API" do

  before(:each) do
    @specialty = create(:specialty)
    @video = create(:video, specialty: @specialty)
    FactoryGirl.create(:question, video: @video)
  end

  it "retrieves a specified number of questions" do
    
    get 'api/v1/questions/sample'

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json['questions'].length).to eq(1)
  end

end