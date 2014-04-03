class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user, presence: true
  validates :content, presence: true
  validates :commentable, presence: true
end
