class Vimeo < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true

  def self.cached_find(user_id, video_id)
    Rails.cache.fetch([name, user_id, video_id]) { User.cached_find(user_id).vimeos.where(video_id: video_id).first }
  end

  def self.register_ids(video_id, user)
    watched = self.find_by(user_id: user.id, video_id: video_id)
    unless watched
      watched = user.vimeos.create(video_id: video_id)
    end
    watched.progress
  end

  def self.pause_video(user_id, params)
    video_id = get_video(params[:path])
    vimeo = self.where(user_id: user_id).where(video_id: video_id).first
    vimeo.update_attributes(progress: params[:progress])
  end

  def self.video_completed(user_id, params)
    user = User.find_by(id: user_id)
    video = get_video(params[:path])
    vimeo = self.where(user_id: user_id).where(video_id: video.id).first
    unless vimeo.completed
      vimeo.update_attributes(completed: true)
      user.add_points(:watched_video)
      UserProgress.new(video.specialty, user).award_badge
    end
  end

  def self.flush_cache(user_id, params)
    Rails.cache.delete([name, user_id, get_video(params[:path])])
  end

private

  def self.get_video(path)
    video_name = path.gsub(/\/videos\//, "")
    Video.friendly.find(video_name)
  end

end
