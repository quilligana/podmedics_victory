class Post < ActiveRecord::Base

  belongs_to :author
  validates :title, :content, presence: true

end
