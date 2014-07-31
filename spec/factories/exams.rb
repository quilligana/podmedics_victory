# == Schema Information
#
# Table name: exams
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  specialty_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  percentage   :integer          default(0)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exam do
    user_id 1
    specialty_id 1
  end
end
