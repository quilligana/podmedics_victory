# == Schema Information
#
# Table name: exams
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  specialty_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  percentage   :integer          default(0)
#

require 'spec_helper'

describe Exam do
  it { should respond_to :user_id }
  it { should respond_to :specialty_id }
  it { should respond_to :percentage }
  it { should belong_to :user }
  it { should belong_to :specialty }

  before(:each) do
    @specialty = create(:specialty)
    @user = create(:user)
  end

  describe Exam, '#register_exam' do
    it 'should add a row to the exam table' do
      expect do
        Exam.register_exam(@specialty.id, @user)
      end.to change { Exam.count }.by(1)
    end
  end

  describe Exam, '#log_result' do
    it 'should log the percentage result a user achieved in an exam' do
      exam_1 = @user.exams.create(specialty_id: @specialty.id)
      percentage = 50

      expect do
        exam_1.log_result(percentage)
      end.to change { exam_1.percentage }.from(0).to(50)
    end
  end
end
