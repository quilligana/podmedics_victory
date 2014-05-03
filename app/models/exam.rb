class Exam < ActiveRecord::Base

  belongs_to :user
  belongs_to :specialty

  validates :user_id, presence: true
  validates :specialty_id, presence: true

  def self.register_exam(specialty_id, user)
    unless self.find_by(user_id: user.id, specialty_id: specialty_id)
      user.exams.create(specialty_id: specialty_id)
    end
  end

  def log_result(percent)
    update_attributes(percentage: percent)
  end

end
