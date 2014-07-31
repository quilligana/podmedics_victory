# == Schema Information
#
# Table name: user_questions
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  question_id    :integer
#  correct_answer :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_question, :class => 'UserQuestion' do
    user_id 1
    question_id 1
    correct_answer false
  end
end
