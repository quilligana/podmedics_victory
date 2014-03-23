# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    sequence(:stem)  { |n| "This is stem number #{n}." }
    answer_1 "First Answer"
    answer_2 "Second Answer"
    answer_3 "Third Answer"
    answer_4 "Fourth Answer"
    answer_5 "Fifth Answer"
    sequence(:correct_answer)  { |n| n }
    explanation "Some explanation as to why an answer is correct."
    association :video
  end
end
