class Category < ActiveRecord::Base

  has_many :specialties
  has_many :videos, through: :specialties

  validates :name, presence: true

  def video_count
    videos.count
  end
end
