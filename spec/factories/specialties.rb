FactoryGirl.define do
  factory :specialty do
    sequence(:name) { |n| "Cardiology#{n}" }
    association :category
  end
end
