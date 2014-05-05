# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_event do
    stripe_id "MyString"
    stripe_type "MyString"
  end
end
