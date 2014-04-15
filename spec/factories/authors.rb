require 'faker'

FactoryGirl.define do
  factory :author do
    name { Faker::Name.name }
    tagline { Faker::Lorem.sentence }
    twitter { Faker::Internet.url }
    facebook  { Faker::Internet.url }
  end
end
