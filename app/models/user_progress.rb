class UserProgress

  def initialize(specialty, user)
    @specialty = specialty
    @user = user
  end

  def max_specialty_points
    video_points = @specialty.cached_videos_count * POINTS_PER_WATCHED_VIDEO
    question_points = @specialty.cached_questions_count * POINTS_PER_CORRECT_ANSWER
    # TODO: Add count of questions asked by users in specialty (POINTS_PER_USER_QUESTION_ANSWERED)
    video_points + question_points
  end

  def user_specialty_points
    specialty_points(@user)
  end

  def current_badge
    badge ||= Badge.where(user_id: @user.id).where(specialty_id: @specialty.id).last
  end

  def next_badge
    if grade_level.nil?
      grades(0)
    elsif grade_level <= 4
      grades(grade_level + 1)
    end
  end

  def next_badge_points
    if next_badge == "Professor"
      professor_points
    else
      get_points_percentage(eval("PERCENTAGE_#{ next_badge.gsub(/ /, '_').upcase }"))
    end
  end

  def professor_points
    if @specialty.professor && @specialty.professor != @user.id
      current_professor = User.find(@specialty.professor)
      specialty_points(current_professor) + 1
    else
      max_specialty_points
    end
  end

  def award_badge
    if current_badge.nil?
        award_first_badge if grade_level == 0
    elsif current_badge.level != grades(grade_level)
      award_higher_badges if grade_level < 5
      check_professor_badge if grade_level == 5
    end
  end

  def award_first_badge
    new_badge = @user.badges.create(specialty_id: @specialty.id, level: grades(grade_level))
    UserMailer.badge_award(@user, new_badge).deliver
  end

  def award_higher_badges
    new_badge = @user.badges.create(specialty_id: @specialty.id, level: grades(grade_level))
    UserMailer.badge_award(@user, new_badge).deliver
  end

  def check_professor_badge
    if @specialty.professor
      current_professor = User.find(@specialty.professor)
      unless specialty_points(current_professor) >= user_specialty_points
        current_professor.badges.find_by(specialty_id: @specialty.id, 
                                        level: "Professor").destroy
        # TODO - Send Email to old professor
        award_professor_badge
      end
    else
      award_professor_badge
    end
  end

  def award_professor_badge
    new_badge = @user.badges.create(specialty_id: @specialty.id, level: grades(-1))
    UserMailer.badge_award(@user, new_badge).deliver
    @specialty.change_professor(@user.id)
  end

private

  def specialty_points(user)
    # TODO: Count of user questions answered
    video_ids = @specialty.video_ids
    videos_watched = user.vimeos.where("video_id IN (?)", video_ids).
                      where(completed: true).count
    video_points = videos_watched * POINTS_PER_WATCHED_VIDEO
    q_ids = Question.where("video_id IN (?)", video_ids).pluck(:id)
    question_points = UserQuestion.number_correct(user.id, q_ids) *
                      POINTS_PER_CORRECT_ANSWER
    video_points + question_points
  end

  def grades(level)
    grade_levels = ["Medical Student", "House Officer", "Senior House Officer",
      "Registrar", "Consultant", "Professor"]
    grade_levels[level] unless level.nil?
  end

  def grade_level
    if user_specialty_points >= professor_points
      5
    elsif user_specialty_points >= get_points_percentage(PERCENTAGE_CONSULTANT)
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
    (percentage * max_specialty_points / 100).round
  end
  
end