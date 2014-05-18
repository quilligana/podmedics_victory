class UnlockedSpecialty < ActiveRecord::Base
  belongs_to :user
  belongs_to :specialty
end
