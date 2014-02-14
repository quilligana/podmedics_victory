class Video < ActiveRecord::Base
  belongs_to :specialty
  has_many :questions

  validates :title, :presence => true
  validates :description, :presence => true
  validates :specialty_id, :presence => true
  validates :duration, :presence => true
  validates :vimeo_identifier, :presence => true
end
