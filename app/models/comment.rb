class Comment < ActiveRecord::Base
  include Commentable
  
  default_scope { includes(:votes, :comments, :user).order(created_at: :desc) }

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :root, polymorphic: true, touch: true
  belongs_to :user, touch: true
  
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :user, presence: true
  validates :content, presence: true
  validates :commentable, presence: true

  delegate :name, to: :user, prefix: true

  before_create :set_root
  before_create :owner_vote

  # Caching functions

  def cached_user
    User.cached_find(user_id)
  end

  def self.available
    where(hidden: false)
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

  def accept
    update_attributes(accepted: true) if acceptable?
  end

  def vote(user)
    if votable?
      @vote = self.votes.find_by(user: user) || self.votes.new(user: user)
      if @vote.save
        voted_user = User.find(self.user_id)
        voted_user.add_points(:upvote)
        specialty = SpecialtyQuestion.find_by(id: self.commentable_id).specialty
        UserProgress.new(specialty, voted_user).award_badge
      end
    end
  end

  def score
    (accepted ? 5 : 0) + votes.size
  end

  # Override commentable methods related to nested_comments

  def comments_count(include_hidden = false)
    only_available(include_hidden, comments).size
  end

  private

    def owner_vote
      vote(user)
    end

    def set_root
      self.root = 
        if commentable_type == "Comment"
          commentable.root 
        else
          commentable
        end
    end
end
