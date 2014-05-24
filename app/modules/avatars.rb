module Avatars

  # Avatar file name

  def set_avatar_file_name
    unless avatar_file_name.nil?
      extension = File.extname(self.avatar_file_name)
      self.avatar_file_name = self.id.to_s + extension
    end
  end

  def get_avatar(style)
    if avatar.exists?
      avatar.url(style)
    else
      ActionController::Base.helpers.asset_path('avatar-128.jpg')
    end
  end
  
end