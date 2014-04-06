class UserProgress

  def initialize(specialty, user)
    @specialty = specialty
    @user = user
  end

  def max_specialty_points
    video_ids = @specialty.video_ids
    video_points = video_ids.count * POINTS_PER_WATCHED_VIDEO
    question_points = @specialty.questions.count * POINTS_PER_CORRECT_ANSWER
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

  private

    def grade_level
      case self.user_specialty_points
      when >= get_points_percentage(PERCENTAGE_MEDICAL_STUDENT)
        "Medical Student"
      when >= get_points_percentage(PERCENTAGE_HOUSE_OFFICER)
        "House Officer"
      when >= get_points_percentage(PERCENTAGE_SENIOR_HOUSE_OFFICER)
        "Senior House Officer"
      when >= get_points_percentage(PERCENTAGE_REGISTRAR)
        "Registrar"
      when >= get_points_percentage(PERCENTAGE_CONSULTANT)
        "Consultant"
      end
    end

    def get_points_percentage(percentage)
      percentage * self.max_specialty_points / 100
    end
  
  
end