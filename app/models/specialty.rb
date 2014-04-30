class Specialty < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  after_commit :flush_cache

  belongs_to :category
  
  has_many :videos, -> { order("position ASC") }
  has_many :questions, through: :videos
  has_many :badges, dependent: :destroy
  has_many :user_questions, class_name: 'SpecialtyQuestion'
  has_many :notes, dependent: :destroy
  # These are notes made directly on a specialty
  has_many :direct_notes, as: :noteable, dependent: :destroy, class_name: "Note"

  validates :name, presence: true

  delegate :name, to: :category, prefix: true

  # Cache functions

  def self.cached_find(id)
    Rails.cache.fetch([name, id], expires_in: 5.minutes) { find(id) }
  end

  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end

  def cached_notes_count
    Rails.cache.fetch([self, "notes_count"]) { notes.size }
  end

  def cached_videos_count
    Rails.cache.fetch([self, "videos_count"]) { videos.size }
  end

  def cached_questions_count
    Rails.cache.fetch([self, "questions_count"]) { questions.size }
  end

  def title
    name
  end
end
