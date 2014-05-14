module QuestionsHelper

  def test_progress
    ProgressBar.new(@quiz.question_number, @quiz.total_questions, self).test_progress
  end

  def get_number_correct
    GeneralUserPerformance.new(@quiz.get_current_id, self).get_number_correct
  end

  def get_next_badge(user_progress, specialty)
    if user_progress.next_badge
      ProgressBar.new(user_progress.user_specialty_points,
                      user_progress.next_badge_points, self).
                      next_badge(Badge.new(user_id: current_user,
                      specialty_id: specialty.id,
                      level: user_progress.next_badge))
    elsif user_progress.current_badge
      content_tag(:p, "You are currently the professor of 
                      #{specialty.name}") +
      show_badge(Badge.new(user_id: current_user,
                      specialty_id: specialty.id,
                      level: user_progress.current_badge.level))
    end
  end

end
