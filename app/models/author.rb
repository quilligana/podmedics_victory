class Author < ActiveRecord::Base

  has_many :videos
  validates :name, :tagline, presence: true

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  },  bucket: ENV['S3_AVATAR_BUCKET_NAME'], 
      default_url: ActionController::Base.helpers.asset_path('avatar-128.jpg')

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  before_save :set_avatar_file_name

  # Avatar file name

  def set_avatar_file_name
    unless avatar_file_name.nil?
      extension = File.extname(self.avatar_file_name)
      self.avatar_file_name = self.id.to_s + extension
    end
  end

end
