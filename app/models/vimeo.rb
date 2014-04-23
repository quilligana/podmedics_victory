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

  def self.pause_video(user_id, params)
    video_id = get_video(params[:path])
    vimeo = self.where(user_id: user_id).where(video_id: video_id).first
    vimeo.update_attributes(progress: params[:progress])
  end

  def self.video_completed(user_id, params)
    video_id = get_video(params[:path])
    vimeo = self.where(user_id: user_id).where(video_id: video_id).first
    unless vimeo.completed
      vimeo.update_attributes(completed: true)
    end
  end

private

  def self.get_video(path)
    video_name = path.gsub(/\/videos\//, "")
    Video.friendly.find(video_name).id
  end

end
