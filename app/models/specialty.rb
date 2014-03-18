class Specialty < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :category
  has_many :videos

  validates_presence_of :name

  delegate :name, to: :category, prefix: true
end
