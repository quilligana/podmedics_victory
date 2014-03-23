class UserQuestion < ActiveRecord::Base

  belongs_to :user, dependent: :destroy

  validates :user_id, :presence => true
  validates :question_id, :presence => true

  def self.register_ids(q_ids, user)
    q_ids.each do |q_id|
      if UserQuestion.find_by(user_id: user.id, question_id: q_id)
      else
        UserQuestion.create(user_id: user.id, question_id: q_id)
      end
    end
  end
end
