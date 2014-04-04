require 'spec_helper'

describe UserProgress do

  test_user = FactoryGirl.create(:user)
  test_specialty = FactoryGirl.create(:specialty)
  video = FactoryGirl.create(:video, specialty: test_specialty)
  question = FactoryGirl.create(:question, video: video)

  it 'should be instantiated with a specialty and a user arguement' do
      expect { UserProgress.new(test_specialty, test_user) }.not_to raise_error
      expect { UserProgress.new }.to raise_error
  end

  let!(:result) { UserProgress.new(test_specialty, test_user) }
  subject { result }

  it { should respond_to(:max_specialty_points) }
  it { should respond_to(:user_specialty_points) }
  it { should respond_to(:badges) }
end