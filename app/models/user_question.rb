class UserQuestion < ActiveRecord::Base

  belongs_to :user

  validates :user_id, :presence => true
  validates :question_id, :presence => true
  validates :correct_answer, :presence => true
end
