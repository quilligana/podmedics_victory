class Question < ActiveRecord::Base

  belongs_to :video

  validates :title, :presence => true
  validates :description, :presence => true
  validates :specialty_id, :presence => true
  validates :duration, :presence => true
  validates :vimeo_identifier, :presence => true

  delegate :specialty_id, to: :video
end
