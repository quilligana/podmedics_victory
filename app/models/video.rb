class Video < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :specialty
  acts_as_list scope: :specialty

  has_many :questions, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :nested_comments, as: :root, class_name: "Comment"

  validates :title, :presence => true
  validates :description, :presence => true
  validates :specialty_id, :presence => true
  validates :duration, :presence => true
  validates :vimeo_identifier, :presence => true
  validates :file_name, :presence => true

  delegate :name, to: :specialty, prefix: true

  def self.recent
    order(created_at: :desc)
  end

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      video = find_by_id(row["id"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      video.update(parameters.permit(:id, :title, :description, :vimeo_identifier, :duration, :specialty_id,
                                    :preview, :created_at, :updated_at, :views, :speaker_name, :file_name))
      video.save!
    end
  end

  def comments_count(visible_only)
    if visible_only
      comments = self.nested_comments.where(hidden: false)
    else
      comments = self.nested_comments
    end

    return comments.count
  end
end
