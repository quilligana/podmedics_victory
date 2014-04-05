class Video < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :specialty
  has_many :questions, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

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

  # Recursively counts the amount of comments on a video, following down the comment tree.
  # only_visible lets you get the full count or only unhidden comments
  def comment_count(only_visible)
    if(only_visible)
      comments = self.comments.where(hidden: false)
    else
      comments = self.comments
    end

    count = comments.count

    comments.each do |comment|
      count += comment.comments_count(only_visible)
    end

    return count
  end

end
