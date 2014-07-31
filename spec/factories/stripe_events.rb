# == Schema Information
#
# Table name: stripe_events
#
#  id          :integer          not null, primary key
#  stripe_id   :string(255)
#  stripe_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_event do
    stripe_id "MyString"
    stripe_type "MyString"
  end
end
