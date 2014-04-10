class SpecialtyQuestion < ActiveRecord::Base
  belongs_to :user
  belongs_to :specialty

  has_many :answers, as: :commentable, class_name: "Comment", dependent: :destroy
  has_many :nested_answers, as: :root, class_name: "Comment"

  def comments_count(include_hidden = false)
    unless include_hidden
      answers = self.nested_answers.where(hidden: false)
    else
      answers = self.nested_answers
    end

    return answers.count
  end

  def get_answers(include_hidden = false)
    unless include_hidden
      answers = self.answers.where(hidden: false).order(created_at: :desc)
    else
      answers = self.answers.order(created_at: :desc)
    end

    return answers.sort_by(&:score).reverse
  end

  def accept_answer(answer, user)
    unless self.already_accepted_answer?
      if self.user == user
        answer.accept
      end
    end
  end

  def accepted_answer
    return self.nested_answers.find_by(accepted: true)
  end

  def already_accepted_answer?
    if self.nested_answers.where(accepted: true).count > 0
      return true
    else
      return false
    end
  end
end
