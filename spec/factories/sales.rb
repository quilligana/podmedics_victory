FactoryGirl.define do
  factory :sale do
    email "test@example.com"
    guid "randomgeneratedstring"
    association :product
  end
end
