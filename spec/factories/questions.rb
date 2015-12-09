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
#  specialty_id   :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    sequence(:stem)  { |n| "This is stem number #{n}." }
    answer_1 "First Answer"
    answer_2 "Second Answer"
    answer_3 "Third Answer"
    answer_4 "Fourth Answer"
    answer_5 "Fifth Answer"
    correct_answer 2
    explanation "Some explanation as to why an answer is correct."
    association :video
    association :specialty
  end
end
