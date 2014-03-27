class UserQuestion < ActiveRecord::Base

  belongs_to :user, dependent: :destroy

  validates :user_id, :presence => true
  validates :question_id, :presence => true

  def self.register_ids(q_ids, user)
    q_ids.each do |q_id|
      unless self.find_by(user_id: user.id, question_id: q_id)
        self.create(user_id: user.id, question_id: q_id)
      end
    end
  end

  def self.save_answer(q_id, user_id, answer)
    user_question = self.where(question_id: q_id).where(user_id: user_id).first

    if answer == "true" && user_question.correct_answer == false
      user_question.update_attributes(correct_answer: true)
      User.add_points(user_question.user)
    end
  end

end
