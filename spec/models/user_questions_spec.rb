require 'spec_helper'

describe UserQuestion do

  let(:user) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question, video: create(:video)) }
  before do
    @user_question = user.user_questions.build(question_id: question.id)
  end

  subject { @user_question }
  
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should respond_to :user }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @user_question.user_id = nil }
    it { should_not be_valid }
  end

end
