# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'faker'

FactoryGirl.define do
  factory :category do
    name { "#{Faker::Lorem.word}-category" }
  end
end
