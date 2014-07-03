class SpecialtyQuestion < ActiveRecord::Base
  include Commentable

  belongs_to :user, touch: true
  belongs_to :specialty, touch: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :nested_comments, as: :root, class_name: 'Comment'

  validates :content, presence: true
  validates :user, presence: true
  validates :specialty, presence: true

  def self.recent(num)
    order(created_at: :desc).limit(num)
  end

  # Caching functions

  def cached_user
    User.cached_find(user_id)
  end

  # Accepted Answer functions

  def accept_answer(answer, user)
    if !already_accepted_answer? && self.cached_user == user && answer.acceptable?
      answer.accept
      user.add_points(:accepted_answer)
      UserProgress.new(self.specialty, user).award_badge
    end
  end

  def accepted_answer
    nested_comments.find_by(accepted: true)
  end

  def already_accepted_answer?
    nested_comments.where(accepted: true).size > 0 ? true : false
  end

end
