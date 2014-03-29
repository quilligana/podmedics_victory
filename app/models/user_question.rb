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

  def self.save_answer(q_id, user, answer)
    user_question = self.where(question_id: q_id).where(user_id: user.id).first

    if answer == "true" && user_question.correct_answer == false
      user_question.update_attributes(correct_answer: true)
      user.add_points_for_answer
    end
  end

  def self.percent_who_got_wrong(q_ids, number_incorrect)
      total_examinees = self.uniq.pluck(:user_id).count
      "#{100*self.got_wrong(q_ids, number_incorrect)/total_examinees}%"
  end

  private

    def self.got_wrong(q_ids, number_incorrect)
      number_of_users = 0
      users = self.uniq.pluck(:user_id)
      users.each do |user|
        number_correct = self.where("user_id = ?", user).
                                where("question_id IN (?)", q_ids).
                                where(correct_answer: true).count

        unless number_correct != q_ids.length - number_incorrect
          number_of_users += 1
        end
      end
      number_of_users
    end

end
