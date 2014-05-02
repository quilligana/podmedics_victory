class Video < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  self.per_page = 30

  belongs_to :specialty
  belongs_to :author
  acts_as_list scope: :specialty

  has_many :questions, dependent: :destroy
  has_many :vimeos, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :nested_comments, as: :root, class_name: "Comment"
  has_many :notes, as: :noteable, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :description, presence: true
  validates :specialty_id, presence: true
  validates :duration, presence: true
  validates :vimeo_identifier, presence: true
  validates :file_name, presence: true

  delegate :name, to: :specialty, prefix: true
  delegate :name, to: :author, prefix: true
  delegate :tagline, to: :author, prefix: true
  delegate :twitter, to: :author, prefix: true
  delegate :facebook, to: :author, prefix: true

  # Caching functions

  def cached_comments(include_hidden = false)
    Rails.cache.fetch([self, include_hidden, "comments"]) { get_comments.to_a }
  end

  def cached_comments_count(include_hidden = false)
    Rails.cache.fetch([self, include_hidden, "comments_count"]) { comments_count(include_hidden) }
  end

  def cached_questions_count
    Rails.cache.fetch([self, "questions_count"]) { questions.count }
  end


  # Comment functions

  def comments_count(include_hidden = false)
    include_hidden ? self.nested_comments.size : self.nested_comments.available.size
  end

  def get_comments(include_hidden = false)
    include_hidden ? self.comments.sort_by(&:score).reverse : self.comments.available.sort_by(&:score).reverse
  end

  # Class functions

  def self.recent
    order(created_at: :desc)
  end

  def self.flagged(user)
    if user.vimeos.any?
      unfinished(user.vimeos) | poor_result(user.vimeos) | unwatched(user.vimeos) | self.watched(user.vimeos)
    else
      self.all.includes(:specialty)
    end
  end

  def self.search(param)
    Video.where('title LIKE ?', "%#{param}%")
  end

  # Stat functions

  def increment_views
    Video.increment_counter(:views, self.id)
  end

  # Tags

  def self.tagged_with(name)
    Tag.find_by_name!(name).videos
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  private

    def self.unfinished(vimeos)
      self.where(id: vimeos.where(completed: false).pluck(:video_id)).includes(:specialty)
    end

    def self.poor_result(vimeos)
      user = User.find_by(id: vimeos.first.user_id)
      id_array = []
      vimeos.each do |vimeo|
        if user.user_questions.where(question_id: vimeo.video.question_ids).any?
          questions = user.user_questions.where(question_id: vimeo.video.question_ids)
          results = QuestionResults.new(questions)
          if results.bad_result?
            id_array << vimeo.video_id
          end
        end
      end
      self.where(id: id_array).includes(:specialty)
    end

    def self.unwatched(vimeos)
      self.where.not(id: vimeos.pluck(:video_id)).includes(:specialty)
    end

    def self.watched(vimeos)
      self.where(id: vimeos.where(completed: true).pluck(:video_id)).includes(:specialty)
    end

end
