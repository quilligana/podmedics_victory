class UserQuestions < ActiveRecord::Base
  validates :user_is, :presence => true
  validates :question_id, :presence => true
  validates :correct_answer, :presence => true
end
