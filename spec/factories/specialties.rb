# == Schema Information
#
# Table name: specialties
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  professor   :integer
#

require 'faker'

FactoryGirl.define do
  factory :specialty do
    name { "#{Faker::Lorem.word}-specialty" }
    association :category
  end
end
