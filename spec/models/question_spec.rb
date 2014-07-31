# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  stem           :text
#  answer_1       :string(255)
#  answer_2       :string(255)
#  answer_3       :string(255)
#  answer_4       :string(255)
#  answer_5       :string(255)
#  correct_answer :integer
#  explanation    :text
#  video_id       :integer
#  created_at     :datetime
#  updated_at     :datetime
#  proofread      :boolean          default(FALSE)
#

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

  describe Question, '#get_answer' do
    it "returns the answer text for a given answer" do
      question = create(:question, correct_answer: 3)
      expect(question.get_answer(1)).to eq question.answer_1
    end
  end

end
