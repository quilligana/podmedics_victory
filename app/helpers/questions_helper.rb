module QuestionsHelper

  def test_progress
    ProgressBar.new(@current_question, @total_questions, self).test_progress
  end

  def get_number_correct
    GeneralUserPerformance.new(@q_ids[@current_question], self).get_number_correct
  end

  def get_next_badge
    ProgressBar.new(@user_progress.user_specialty_points, @user_progress.target_points, self).
                    next_badge(@user_progress.next_badge)
  end

end