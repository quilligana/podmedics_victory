class Specialty < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :category
  has_many :videos, -> { order("position ASC") }
  has_many :questions, through: :videos
  has_many :badges, dependent: :destroy

  validates_presence_of :name

  delegate :name, to: :category, prefix: true
end
