class Specialty < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  after_commit :flush_cache
  after_touch :flush_cache

  belongs_to :category
  
  has_many :videos, -> { order("position ASC") }
  has_many :questions, through: :videos
  has_many :specialty_questions, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :user_questions, class_name: 'SpecialtyQuestion'
  has_many :notes, dependent: :destroy
  # These are notes made directly on a specialty
  has_many :direct_notes, as: :noteable, dependent: :destroy, class_name: "Note"
  has_many :exams, dependent: :destroy

  validates :name, presence: true

  delegate :name, to: :category, prefix: true

  def question_status
    ideal_count = self.videos.count * 7
    return 'red' if self.questions.count < ideal_count
  end

  def question_target
    self.videos.count * 7
  end

  # Cache functions

  def self.cached_find(id)
    Rails.cache.fetch([name, id], expires_in: 5.minutes) { find(id) }
  end

  def self.cached_friendly_find(slug)
    Rails.cache.fetch([name, slug], expires_in: 5.minutes) { friendly.find(slug) }
  end

  def flush_cache
    Rails.cache.delete([self.class.name, id])
    Rails.cache.delete([self.class.name, slug])
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

  def cached_specialty_questions_count
    Rails.cache.fetch([self, "specialty_questions_count"]) { user_questions.size }
  end

  def cached_specialty_questions(page)
    Rails.cache.fetch([self, page, "specialty_questions"]) { user_questions.page(page).order('created_at DESC').to_a }
  end

  # These are notes made directly on a specialty
  def cached_specialty_note(user)
    Rails.cache.fetch([self, user.id, "direct_notes"]) { direct_notes.find_by(user: user) }
  end

  # These are all the notes on a specialty, i.e. those on videos for a specialty
  def cached_notes
    Rails.cache.fetch([self, "notes"]) { notes.to_a }
  end

  def change_professor(user_id)
    update_attributes(professor: user_id)
  end

  def title
    name
  end

end
