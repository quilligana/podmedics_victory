class UserProgress

  def initialize(specialty, user)
    @specialty = specialty
    @user = user
  end

  def max_specialty_points
    video_ids = @specialty.video_ids
    video_points = video_ids.count * POINTS_PER_WATCHED_VIDEO
    question_points = Question.where("video_id IN (?)", video_ids).count * POINTS_PER_CORRECT_ANSWER
    # TODO: Add count of questions asked by users in specialty (POINTS_PER_USER_QUESTION_ANSWERED)
    video_points + question_points
  end

  def user_specialty_points
    # TODO: Count of videos watched
    # TODO: Count of user questions answered
    video_ids = @specialty.video_ids
    q_ids = Question.where("video_id IN (?)", video_ids).pluck(:id)
    question_points = UserQuestion.number_correct(@user.id, q_ids) * POINTS_PER_CORRECT_ANSWER
  end

  def badges
    
  end
  
  
end