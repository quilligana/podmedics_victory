require 'spec_helper'

describe Question do

  let(:video) { FactoryGirl.create(:video) }
  before do
    @question = create(:question, video: video)
  end

  subject { @question }

  it { should respond_to :stem }
  it { should respond_to :answer_1 }
  it { should respond_to :answer_2 }
  it { should respond_to :answer_3 }
  it { should respond_to :answer_4 }
  it { should respond_to :answer_5 }
  it { should respond_to :correct_answer }
  it { should respond_to :explanation }
  it { should respond_to :video_id }

  it { should respond_to :video }
  its(:video) { should eq video }

  it { should be_valid }

  describe "when video_id is not present" do
    before { @question.video_id = nil }
    it { should_not be_valid }
  end

  describe "when between 2 and 5 answers are present" do
    before { @question.answer_5 = nil }
    it { should be_valid }
  end

  describe "when less than 2 answers are present" do
    before do
      @question.answer_2 = nil
      @question.answer_3 = nil
      @question.answer_4 = nil
      @question.answer_5 = nil
    end
    it { should_not be_valid }
  end

  it 'should have a valid factory' do
    expect(build(:question)).to be_valid
  end
end
