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
    name { "#{1+rand(10000)}-category" }
  end
end
