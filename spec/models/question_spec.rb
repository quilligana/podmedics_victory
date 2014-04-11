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

end
