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
end
