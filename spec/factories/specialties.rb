FactoryGirl.define do
  factory :specialty do
    name "Cardiology"
    association :category
  end
end
