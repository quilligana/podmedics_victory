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

  default_scope order(created_at: :desc)

  def self.available
    where(hidden: false)
  end

  def get_comments(include_hidden = false)
    unless include_hidden
      comments = self.comments.available
    else
      comments = self.comments
    end

    comments.sort_by(&:score).reverse
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
    root_type == "SpecialtyQuestion"
  end

  def acceptable?
    root_type == "SpecialtyQuestion"
  end

  def already_voted?(user)
    votes.where(user: user).exists? ? true : false
  end

  def owner_vote
    votes.new(user: self.user)
  end

  def accept
    update_attributes(accepted: true) if acceptable?
  end

  def vote(user)
    if votable?
      @vote = self.votes.find_by(user: user) || self.votes.new(user: user)
      @vote.save
    end
  end

  def self.by_score
    sort_by(&:score).reverse
  end

  def score
    votes.count
  end

end
