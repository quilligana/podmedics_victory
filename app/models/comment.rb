class Comment < ActiveRecord::Base
  attr_accessible :content, :commentable_id, :commentable_type

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user, presence: true
end
