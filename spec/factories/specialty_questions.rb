# == Schema Information
#
# Table name: specialty_questions
#
#  id           :integer          not null, primary key
#  content      :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  specialty_id :integer
#

require 'faker'

FactoryGirl.define do
  factory :specialty_question do
    user
    specialty
    content { Faker::Lorem.sentence }
  end
end
