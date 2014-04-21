require 'faker'

FactoryGirl.define do
  factory :comment do
    user
    association :commentable, factory: :video
    content { Faker::Lorem.sentence }
  end

  factory :hidden_comment, parent: :comment do
    hidden true
  end
end

