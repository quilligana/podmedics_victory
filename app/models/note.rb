class Note < ActiveRecord::Base

  belongs_to :noteable, polymorphic: true
  belongs_to :user
  belongs_to :specialty

  validates :content, presence: true

  def get_title
  	title.blank? ? noteable.title : title
  end

end
