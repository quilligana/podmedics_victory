class SpecialtyQuestion < ActiveRecord::Base
  belongs_to :user
  belongs_to :specialty

  has_many :answers, as: :commentable, class_name: 'Comment', dependent: :destroy
  has_many :nested_answers, as: :root, class_name: 'Comment'

  validates :content, presence: true
  validates :user, presence: true
  validates :specialty, presence: true

  def comments_count(include_hidden = false)
    include_hidden ? self.nested_answers.count : self.nested_answers.available.count
  end

  def get_answers(include_hidden = false)
    include_hidden ? self.answers.sort_by(&:score).reverse : self.answers.available.sort_by(&:score).reverse
  end

  def accept_answer(answer, user)
    answer.accept if !already_accepted_answer? && self.user == user && answer.acceptable?
  end

  def accepted_answer
    nested_answers.find_by(accepted: true)
  end

  def already_accepted_answer?
    nested_answers.where(accepted: true).count > 0 ? true : false
  end

end
