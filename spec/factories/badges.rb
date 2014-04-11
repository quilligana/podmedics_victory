FactoryGirl.define do
  factory :badge do
    association :user
    association :specialty
    level 1
  end
end
