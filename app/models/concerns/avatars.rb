module Avatars
  extend ActiveSupport::Concern

  included do
    bucket_name = 
      if self.name == "User"
        ENV['S3_USER_AVATAR_BUCKET_NAME']
      else
        ENV['S3_AVATAR_BUCKET_NAME']
      end

    has_attached_file :avatar,
      styles: {
        thumb: '100x100>',
        square: '200x200#',
        medium: '300x300>'
      }, bucket: bucket_name

    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

    process_in_background :avatar, :processing_image_url => ActionController::Base.helpers.asset_path('avatar-128-pending.jpg')

    before_save :set_avatar_file_name
  end

  def set_avatar_file_name
    unless avatar_file_name.nil?
      extension = File.extname(self.avatar_file_name)
      self.avatar_file_name = self.id.to_s + extension
    end
  end

  def get_avatar(style)
   cached_avatar_url(style)
   if avatar.exists?
     avatar.url(style)
   else
     gravatar_fallback(style)
   end
  end

  def gravatar_fallback(style)
      default_url = ActionController::Base.helpers.asset_url('avatar-128.jpg')
    if self.class.name == "User"
      size = gravatar_size(style)
      gravatar_id = Digest::MD5::hexdigest(email).downcase
      url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI::escape(default_url)}"
    else
      url = default_url
    end
  end

  def gravatar_size(style)
    case style
    when :thumb
      return 100
    when :square
      return 200
    when :medium
      return 300
    end
  end

  def cached_avatar_url(style)
    Rails.cache.fetch([self, "avatar_url", style]) do
      if avatar.exists?
        avatar.url(style)
      else
        ActionController::Base.helpers.asset_path('avatar-128.jpg')
      end
    end
  end  

end
