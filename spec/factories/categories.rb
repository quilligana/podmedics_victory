require 'faker'

FactoryGirl.define do
  factory :category do
    name { "#{Faker::Lorem.word}-category" }
  end
end
