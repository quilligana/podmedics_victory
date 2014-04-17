class Note < ActiveRecord::Base

  belongs_to :video
  belongs_to :user
  belongs_to :specialty

  validates :content, presence: true

  def get_title
  	title.blank? ? video.title : title
  end

end
