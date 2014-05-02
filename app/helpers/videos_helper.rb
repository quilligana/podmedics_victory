module VideosHelper

  def questions_exist
    @video.cached_questions_count > 0
  end

end
