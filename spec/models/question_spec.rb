require 'spec_helper'

describe Question do

  it 'should have a valid factory' do
    expect(build(:question)).to be_valid
  end

  it { should belong_to :video}
  it { should validate_presence_of :stem }
  it { should validate_presence_of :answer_1 }
  it { should validate_presence_of :answer_2 }
  it { should validate_presence_of :correct_answer }
  it { should validate_presence_of :video_id }
  it { should validate_presence_of :explanation }

  describe Question, '.correct_answer_must_be_answer' do
    it "should make sure the correct answer is an answer" do
      bad_question = build(:question, answer_3: nil, correct_answer: 3)
      expect(bad_question).to_not be_valid
    end
  end

  describe Question, '.remaining_to_add' do
    it "returns the number of questions we need to add" do
      target_per_video = 7
      create_list(:video, 10)
      expect(Question.remaining_to_add).to eq 70
    end
  end

  describe Question, '#get_correct_answer' do
    it "return the correct answer text" do
      question = create(:question, correct_answer: 3)
      expect(question.get_correct_answer).to eq question.answer_3
    end
  end

end
