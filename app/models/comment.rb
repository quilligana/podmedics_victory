class Comment < ActiveRecord::Base
  before_create :owner_vote

  belongs_to :commentable, polymorphic: true
  belongs_to :root, polymorphic: true
  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :user, presence: true
  validates :content, presence: true
  validates :commentable, presence: true

  def get_comments(include_hidden = false)
    unless include_hidden
      comments = self.comments.where(hidden: false).order(created_at: :desc)
    else
      comments = self.comments.order(created_at: :desc)
    end

    return comments.sort_by(&:score).reverse
  end

  def hide
    update_attributes(hidden: true)
    comments.each { |comment| comment.hide }
  end

  def show
    update_attributes(hidden: false)
    comments.each { |comment| comment.show }
  end

  def votable?
    return self.root_type == "SpecialtyQuestion"
  end

  def acceptable?
    return self.root_type == "SpecialtyQuestion"
  end

  def already_voted?(user)
    if self.votes.find_by(user: user)
      return true
    else
      return false
    end
  end

  def owner_vote
    self.votes.new(user: self.user)
  end

  def accept
    if acceptable?
      self.accepted = true
      self.save
    end
  end

  def vote(user)
    if votable?
      @vote = self.votes.find_by(user: user) || self.votes.new(user: user)
      @vote.save
    end
  end

  def score
    return self.votes.count
  end
end
