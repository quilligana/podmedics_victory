require 'faker'

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    selected_plan true
    subscribed_on { Time.zone.now }

    factory :free_user do
      subscribed_on nil
    end

    factory :admin_user do
      admin true
    end

    factory :no_plan_user do
      selected_plan false
    end
  end
end
