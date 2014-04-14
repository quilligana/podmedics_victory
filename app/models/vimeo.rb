class Vimeo < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true

  def self.register_ids(video_id, user)
    unless self.find_by(user_id: user.id, video_id: video_id)
      user.vimeos.create(video_id: video_id)
    end
  end

end
