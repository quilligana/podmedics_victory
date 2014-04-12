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

  def current_badge
    badge ||= Badge.where(user_id: @user.id).where(specialty_id: @specialty.id).last
  end

  def next_badge
    if current_badge.name == grades(grade_level)
      grades(grade_level + 1)
    end
  end

  def award_badge?
    if current_badge.nil? && grade_level == 0
      @user.badges.create(specialty_id: @specialty.id, level: grades(grade_level))
    elsif current_badge && current_badge.level != grades(grade_level)
      @user.badges.create(specialty_id: @specialty.id, level: grades(grade_level))
    end
  end

  private

    def grades(level)
      grade_levels = ["Medical Student", "House Officer", "Senior House Officer",
        "Registrar", "Consultant", "Professor"]
      grade_levels[level] unless level.nil?
    end

    def grade_level
      if user_specialty_points >= get_points_percentage(PERCENTAGE_CONSULTANT)
        4
      elsif user_specialty_points >= get_points_percentage(PERCENTAGE_REGISTRAR)
        3
      elsif user_specialty_points >= get_points_percentage(PERCENTAGE_SENIOR_HOUSE_OFFICER)
        2
      elsif user_specialty_points >= get_points_percentage(PERCENTAGE_HOUSE_OFFICER)
        1
      elsif user_specialty_points >= get_points_percentage(PERCENTAGE_MEDICAL_STUDENT)
        0
      end
    end

    def get_points_percentage(percentage)
      percentage * self.max_specialty_points / 100
    end
  
  
end