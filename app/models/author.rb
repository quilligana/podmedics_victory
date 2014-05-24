class Author < ActiveRecord::Base
  include Avatars

  has_many :videos
  validates :name, :tagline, presence: true

  has_attached_file :avatar,
    styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
    }, bucket: ENV['S3_AVATAR_BUCKET_NAME']

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  process_in_background :avatar, :processing_image_url => ActionController::Base.helpers.asset_path('avatar-128-pending.jpg')

  before_save :set_avatar_file_name
  
end
