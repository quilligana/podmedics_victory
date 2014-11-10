require 'spec_helper'

describe "Questions API" do

  it "retrieves 1 question from 10 specialties" do
    # FactoryGirl.create_list(:message, 10)

    get 'api/v1/questions/sample'

    expect(response).to be_success            # test for the 200 status-code
    # json = JSON.parse(response.body)
    # expect(json['messages'].length).to eq(10)
  end

end