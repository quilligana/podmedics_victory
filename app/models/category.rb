# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base

  has_many :specialties,  -> {order 'name ASC'}
  has_many :videos, through: :specialties
  has_many :notes

  validates :name, presence: true

  def video_count
    videos.count
  end

end
