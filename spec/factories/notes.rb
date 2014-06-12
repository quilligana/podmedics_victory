require 'faker'

FactoryGirl.define do
  factory :note do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    user
    association :specialty
    association :category
    association :noteable, factory: :video
  end
end