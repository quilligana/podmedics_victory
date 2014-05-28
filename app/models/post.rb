class Post < ActiveRecord::Base

  belongs_to :author
  validates :title, :content, :author_id, presence: true
  delegate :twitter, to: :author, prefix: true
  delegate :facebook, to: :author, prefix: true

end
