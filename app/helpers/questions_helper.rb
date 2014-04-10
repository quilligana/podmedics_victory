module QuestionsHelper

  def test_progress
    ProgressBar.new(@current_question, @total_questions, self).test_progress
  end

  def get_number_correct
    GeneralUserPerformance.new(@q_ids[@current_question], self).get_number_correct
  end

  def get_next_badge
    content_tag(:p, "50", class: "questions_info_right_column_number") +
    content_tag(:p, "You require 50 more points to recieve a Registrar badge")
  end

end