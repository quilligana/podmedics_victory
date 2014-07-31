# == Schema Information
#
# Table name: badges
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  specialty_id :integer
#  level        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :badge do
    association :user
    association :specialty
    level "Medical Student"
  end
end
