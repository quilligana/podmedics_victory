# == Schema Information
#
# Table name: unlocked_specialties
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  specialty_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :unlocked_specialty do
    association :specialty
    association :user
  end
end
