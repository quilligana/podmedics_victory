class Author < ActiveRecord::Base

  has_many :videos
  validates :name, :tagline, presence: true  
  
  include Avatars
end
