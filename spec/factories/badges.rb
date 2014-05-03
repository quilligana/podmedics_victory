FactoryGirl.define do
  factory :badge do
    association :user
    association :specialty
    level "Medical Student"
  end
end
