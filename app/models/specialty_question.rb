class SpecialtyQuestion < ActiveRecord::Base
  belongs_to :user
  belongs_to :specialty

  has_many :answers, as: :commentable, class_name: "Comment", dependent: :destroy
  has_many :nested_answers, as: :root, class_name: "Comment"

  def comments_count(visible_only)
    if visible_only
      comments = self.nested_answers.where(hidden: false)
    else
      comments = self.nested_answers
    end

    return comments.count
  end

  def accept_answer(comment, user)
    if self.user = user
      self.accepted_answer = comment
    end
  end

  def accepted_answer
    return self.nested_answers.find_by(accepted: true)
  end

  def accepted_answer=(comment)
    comment.accepted = true
    comment.save
  end

  def already_accepted_answer?
    if self.nested_answers.where(accepted: true).count > 0
      return true
    else
      return false
    end
  end
end
