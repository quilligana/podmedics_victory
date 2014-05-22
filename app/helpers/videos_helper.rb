module VideosHelper

  def questions_exist
    @video.questions_count > 0
  end

end
