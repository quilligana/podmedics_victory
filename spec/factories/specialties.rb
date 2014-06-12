require 'faker'

FactoryGirl.define do
  factory :specialty do
    name { "#{Faker::Lorem.word}-specialty" }
    association :category
  end
end
