class Specialty < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category
  
  has_many :videos, -> { order("position ASC") }
  has_many :questions, through: :videos
  has_many :badges, dependent: :destroy
  has_many :user_questions, class_name: 'SpecialtyQuestion'
  has_many :notes, dependent: :destroy

  # These are notes made directly on a specialty
  has_many :direct_notes, as: :noteable, dependent: :destroy, class_name: "Note"

  validates_presence_of :name

  delegate :name, to: :category, prefix: true
end
