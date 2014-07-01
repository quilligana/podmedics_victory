class Category < ActiveRecord::Base

  has_many :specialties,  -> {order 'name ASC'}
  has_many :videos, through: :specialties
  has_many :notes

  validates :name, presence: true

  def video_count
    videos.count
  end

end
