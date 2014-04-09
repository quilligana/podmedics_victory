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
end
