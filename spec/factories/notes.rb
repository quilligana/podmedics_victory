# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  content       :text
#  user_id       :integer
#  specialty_id  :integer
#  created_at    :datetime
#  updated_at    :datetime
#  noteable_id   :integer
#  noteable_type :string(255)
#  category_id   :integer
#

require 'faker'

FactoryGirl.define do
  factory :note do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    user
    association :specialty
    association :category
    association :noteable, factory: :video
  end
end
