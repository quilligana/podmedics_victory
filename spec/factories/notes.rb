require 'faker'

FactoryGirl.define do
  factory :note do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    user
    specialty
    association :noteable, factory: :video
  end
end