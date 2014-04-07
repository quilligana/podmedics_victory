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
    self.save
  end

  def show
    self.hidden = false
    self.save
  end
end
