require 'faker'

FactoryGirl.define do
  factory :user do
    email "MyString"
    password_digest "MyString"

    factory :admin_user do
      admin true
    end
  end
end
