class Category < ActiveRecord::Base
  validates_presence_of :name
  has_many :specialties
  has_many :videos, through: :specialties

  def video_count
    videos.count
  end

end
