# == Schema Information
#
# Table name: videos
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  specialty_id         :integer
#  vimeo_identifier     :string(255)
#  duration             :integer
#  created_at           :datetime
#  updated_at           :datetime
#  preview              :boolean          default(FALSE)
#  slug                 :string(255)
#  speaker_name         :string(255)
#  views                :integer          default(0)
#  file_name            :string(255)
#  questions_count      :integer          default(0), not null
#  position             :integer
#  author_id            :integer
#  slide_download_count :integer
#  audio_download_count :integer
#  video_download_count :integer
#  proofread            :boolean          default(FALSE)
#

class Video < ActiveRecord::Base
  include Commentable
  
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

  after_save :touch_assets

  def mark_proofread
    questions.each { |q| q.update_attributes(proofread: true) }
  end

  def is_proofread?
    questions.where(proofread: true).count == questions.count ? true : false
  end

  # Caching functions

  def touch_assets
    notes.each { |note| note.touch }
  end

  def cached_questions_count
    Rails.cache.fetch([self, "questions_count"]) { questions.count }
  end

  # Class functions

  def self.recent
    order(id: :desc)
  end

  def self.flagged(user)
    if user.vimeos.any?
      # temp removed poor_result method until we can make it faster
      unfinished(user.vimeos) | unwatched(user.vimeos) |  self.watched(user.vimeos)
    else
      self.all
    end
  end

  # searches by case insensitive title and tags
  def self.search_with(param)
    videos = Video.where('title ILIKE ?', "%#{param}%") + Video.pessimistic_tagged_with(param)
    videos.uniq
  end

  # Stat functions

  def increment_views
    Video.increment_counter(:views, self.id)
  end

  def question_status
    return "red" if self.questions.count < 7
  end

  # Tags

  def self.tagged_with(name)
    Tag.find_by_name!(name).videos
  end

  def self.pessimistic_tagged_with(name)
    tag = Tag.where(name: name).first
    tag ? tag.videos : []
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  # Notifications

  def send_video_notification
    User.episode_notifications_allowed.each do |user|
      UserMailer.delay.new_episode(user, self)
    end
  end
  handle_asynchronously :send_video_notification

  def send_test_notification
    AdminMailer.delay.new_test_episode(self)
  end

  private

    def self.unfinished(vimeos)
      self.where(id: vimeos.where(completed: false).pluck(:video_id)).includes(:specialty)
    end

    def self.poor_result(vimeos)
      user = User.find_by(id: vimeos.first.user_id)
      id_array = []
      vimeos.includes(:video).each do |vimeo|
        if user.user_questions.where(question_id: vimeo.video.question_ids).any?
          questions = user.user_questions.where(question_id: vimeo.video.question_ids)
          results = QuestionResults.new(questions, vimeo.video.question_ids.count)
          if results.bad_result?
            id_array << vimeo.video_id
          end
        end
      end
      self.where(id: id_array).includes(:specialty)
    end

    def self.unwatched(vimeos)
      self.where.not(id: vimeos.pluck(:video_id))
    end

    def self.watched(vimeos)
      self.where(id: vimeos.where(completed: true).pluck(:video_id)).includes(:specialty)
    end

end
