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

class UnlockedSpecialty < ActiveRecord::Base
  belongs_to :user
  belongs_to :specialty
end
