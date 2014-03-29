module QuestionsHelper

  def test_progress
    ProgressBar.new(@current_question, @total_questions, self).test_progress
  end

  def get_swots(number_incorrect)
    GeneralUserPerformance.new(@q_ids, number_incorrect, self).get_swots
  end

end