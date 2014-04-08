class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :root, polymorphic: true
  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user, presence: true
  validates :content, presence: true
  validates :commentable, presence: true

  def hide
    update_attributes(hidden: true)
    comments.each { |comment| comment.hide }
  end

  def show
    update_attributes(hidden: false)
    comments.each { |comment| comment.show }
  end

end
