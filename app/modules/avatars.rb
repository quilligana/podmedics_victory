module Avatars

  # Avatar file name

  def set_avatar_file_name
    unless avatar_file_name.nil?
      extension = File.extname(self.avatar_file_name)
      self.avatar_file_name = self.id.to_s + extension
    end
  end

  def get_avatar(style)
    cached_avatar_url(style)
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