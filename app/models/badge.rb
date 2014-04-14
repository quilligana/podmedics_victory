class Badge < ActiveRecord::Base
  belongs_to :user
  belongs_to :specialty
  validates :user_id, presence: true
  validates :specialty_id, presence: true
  validates :level, presence: true
end
