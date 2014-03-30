module VideosHelper

  def questions_exist
    Question.includes(:video_id).where(video_id: @video.id).any?
  end
end