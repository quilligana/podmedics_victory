class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :video
  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user, presence: true
  validates :content, presence: true
  validates :commentable, presence: true

  def hide
    self.hidden = true

    self.comments.each do |comment|
      comment.hide()
    end

    self.save
  end

  def show
    self.hidden = false

    self.comments.each do |comment|
      comment.show()
    end

    self.save
  end
end
