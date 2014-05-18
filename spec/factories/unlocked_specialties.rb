FactoryGirl.define do
  factory :unlocked_specialty do
    association :specialty
    association :user
  end
end
