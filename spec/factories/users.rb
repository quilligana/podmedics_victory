require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'

    factory :admin_user do
      admin true
    end
  end
end
