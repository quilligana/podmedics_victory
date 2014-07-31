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

class Badge < ActiveRecord::Base

  belongs_to :user, touch: true
  belongs_to :specialty

  validates :user_id, presence: true
  validates :specialty_id, presence: true
  validates :level, presence: true
  

  def level_to_num
    case level
    when "Medical Student"
      return 0
    when "House Officer"
      return 1
    when "Senior House Officer"
      return 2
    when "Registrar"
      return 3
    when "Consultant"
      return 4
    when "Professor"
      return 5
    end
  end

 
end
