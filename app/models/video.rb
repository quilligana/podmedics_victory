class Video < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :specialty
  belongs_to :author
  acts_as_list scope: :specialty

  has_many :questions, dependent: :destroy
  has_many :vimeos, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :nested_comments, as: :root, class_name: "Comment"
  has_one :note, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :specialty_id, presence: true
  validates :duration, presence: true
  validates :vimeo_identifier, presence: true
  validates :file_name, presence: true

  delegate :name, to: :specialty, prefix: true

  def self.recent
    order(created_at: :desc)
  end

  def comments_count(include_hidden = false)
    include_hidden ? self.nested_comments.count : self.nested_comments.available.count
  end

  def get_comments(include_hidden = false)
    include_hidden ? self.comments.sort_by(&:score).reverse : self.comments.available.sort_by(&:score).reverse
  end

end
