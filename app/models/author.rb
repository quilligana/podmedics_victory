class Author < ActiveRecord::Base

  has_many :videos
  validates :name, :tagline, presence: true

  has_attached_file :avatar, 
    styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
    },
    bucket: ENV['S3_AVATAR_BUCKET_NAME']

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  process_in_background :avatar

  before_save :set_avatar_file_name

  # Avatar file name

  def set_avatar_file_name
    unless avatar_file_name.nil?
      extension = File.extname(self.avatar_file_name)
      self.avatar_file_name = self.id.to_s + extension
    end
  end

  def get_avatar(style)
    # if avatar.exists?
    #   avatar.url(style)
    # else
    #   ActionController::Base.helpers.asset_path('avatar-128.jpg')
    # end
  end
  
end
