class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user, presence: true
  validates :content, presence: true
  validates :commentable, presence: true

  # Navigates up through a comment tree to get the original commentable e.g. a video
  def get_root_commentable
    comment_parent = self
    
    while comment_parent.commentable_type == "Comment" do
      comment_parent = comment_parent.commentable
    end

    return comment_parent.commentable
  end

  # Recursively counts the amount of nested comments, following down the comment tree.
  # only_visible lets you get the full count or only unhidden comments
  def comment_count(only_visible)
    if(only_visible)
      comments = self.comments.where(hidden: false)
    else
      comments = self.comments
    end
    
    count = comments.count

    comments.each() do |comment|
      count += comment.comment_count(only_visible)
    end

    return count
  end

  def hide
    self.hidden = true
    self.save
  end

  def show
    self.hidden = false
    self.save
  end
end
