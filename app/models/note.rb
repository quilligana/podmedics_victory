class Note < ActiveRecord::Base

  belongs_to :video
  belongs_to :user
  belongs_to :specialty

  validates :content, presence: true
  validates :title, presence: true

end