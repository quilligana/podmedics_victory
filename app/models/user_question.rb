class UserQuestion < ActiveRecord::Base

  belongs_to :user

  validates :user_id, :presence => true
  validates :question_id, :presence => true

  def self.register_ids(q_ids, user)
    q_ids.each do |q_id|
      unless self.find_by(user_id: user.id, question_id: q_id)
        self.create(user_id: user.id, question_id: q_id)
      end
    end
  end

  def self.save_answer(q_id, user, answer)
    user_question = self.where(question_id: q_id).where(user_id: user.id).first

    if answer == "true" && user_question.correct_answer == false
      user_question.update_attributes(correct_answer: true)
      user.add_points_for_answer
    end
  end

  def self.percent_who_got_correct(q_id)
      total = self.where(question_id: q_id).count
      correct = self.where(question_id: q_id).
                     where(correct_answer: true).count
      "#{ 100 * correct / (total.nonzero? || 1) }%"
  end

  private

    def self.number_correct(user_id, q_ids)
      self.where(user_id: user_id).where(question_id: q_ids).
           where(correct_answer: true).count
    end

end
