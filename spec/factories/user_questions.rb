# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_question, :class => 'UserQuestion' do
    user_id 1
    question_id 1
    correct_answer false
  end
end
