class UserProgress

  def initialize(specialty, user)
    @specialty = specialty
    @user = user
  end

  def max_specialty_points
    # Points for answering specialty_questions are not included
    video_points = @specialty.cached_videos_count * POINTS[:watched_video]
    question_points = @specialty.cached_questions_count * POINTS[:correct_answer]
    (video_points + question_points) * 1.2
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

  def due_badge?
    if current_badge.nil?
        true if grade_level == 0
    elsif current_badge.level != grades(grade_level)
      true if grade_level <= 5
    else
      false
    end
  end

  def award_badge
    if current_badge.nil?
      award_first_badge if grade_level == 0
    elsif current_badge.level != grades(grade_level)
      award_higher_badges if grade_level <= 5
    end
  end

  def award_first_badge
    if grade_level < 5
      new_badge = @user.badges.create(specialty_id: @specialty.id, level: grades(grade_level))
      UserMailer.delay.badge_award(@user, new_badge)
    elsif grade_level == 5
      check_professor_badge
    end
  end

  def award_higher_badges
    new_badge = @user.badges.create(specialty_id: @specialty.id, level: grades(grade_level))
    UserMailer.delay.badge_award(@user, new_badge)
  end

  def check_professor_badge
    if @specialty.professor
      current_professor = User.find(@specialty.professor)
      unless specialty_points(current_professor) >= user_specialty_points
        current_professor.badges.find_by(specialty_id: @specialty.id, 
                                        level: "Professor").destroy
        UserMailer.delay.professor_loss(@user, @specialty)
        award_professor_badge
      end
    else
      award_professor_badge
    end
  end

  def award_professor_badge
    new_badge = @user.badges.create(specialty_id: @specialty.id, level: grades(-1))
    UserMailer.delay.badge_award(@user, new_badge)
    @specialty.change_professor(@user.id)
  end

private

  def specialty_points(user)
    spec_q_ids = @specialty.specialty_question_ids
    # raise spec_q_ids
    answers = Comment.where(user_id: user.id).where(commentable_type: "SpecialtyQuestion").
                                 where("commentable_id IN (?)", spec_q_ids)
    answer_points = answers.count * POINTS[:answered_user_question]
    accepted_answer_points =  answers.where(accepted: true).count * POINTS[:accepted_answer]
    video_ids = @specialty.video_ids
    videos_watched = user.vimeos.where("video_id IN (?)", video_ids).
                      where(completed: true).count
    video_points = videos_watched * POINTS[:watched_video]
    q_ids = Question.where("video_id IN (?)", video_ids).pluck(:id)
    question_points = UserQuestion.number_correct(user.id, q_ids) *
                      POINTS[:correct_answer]
    video_points + question_points + answer_points + accepted_answer_points
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
