require 'faker'

FactoryGirl.define do
  factory :specialty_question do
    user
    specialty
    content { Faker::Lorem.sentence }
  end
end
