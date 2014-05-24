class SpecialtyQuestion < ActiveRecord::Base

  belongs_to :user, touch: true
  belongs_to :specialty, touch: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :nested_comments, as: :root, class_name: 'Comment'

  validates :content, presence: true
  validates :user, presence: true
  validates :specialty, presence: true

  # Caching functions

  def cached_user
    User.cached_find(user_id)
  end
  
  def cached_comments(include_hidden = false)
    Rails.cache.fetch([self, include_hidden, "comments"]) { get_comments(include_hidden).to_a }
  end

  def cached_comments_count(include_hidden = false)
    Rails.cache.fetch([self, include_hidden, "comments_count"]) { comments_count(include_hidden) }
  end  

  # Answer functions

  def get_comments(include_hidden = false)
    include_hidden ? self.comments.sort_by(&:score).reverse : self.comments.available.sort_by(&:score).reverse
  end

  def comments_count(include_hidden = false)
    include_hidden ? self.nested_comments.size : self.nested_comments.available.size
  end  


  # Accepted Answer functions

  def accept_answer(answer, user)
    if !already_accepted_answer? && self.cached_user == user && answer.acceptable?
      answer.accept
      user.add_points_for_accepted_answer
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
