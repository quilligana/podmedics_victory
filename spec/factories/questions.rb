# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    stem "MyText"
    answer_1 "MyString"
    answer_2 "MyString"
    answer_3 "MyString"
    answer_4 "MyString"
    answer_5 "MyString"
    correct_answer 1
    explanation "MyText"
    video nil
  end
end
