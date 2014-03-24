require 'spec_helper'

describe Question do

  it { should belong_to :video }
  it { should validate_presence_of :stem }
  it { should validate_presence_of :answer_1 }
  it { should validate_presence_of :answer_2 }
  it { should validate_presence_of :answer_3 }
  it { should validate_presence_of :answer_4 }
  it { should validate_presence_of :answer_5 }
  it { should validate_presence_of :correct_answer }
  it { should validate_presence_of :explanation }
  it { should validate_presence_of :video_id }

  it 'should have a valid factory' do
    expect(build(:question)).to be_valid
  end
end
