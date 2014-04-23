module QuestionsHelper

  def test_progress
    ProgressBar.new(@current_question, @total_questions, self).test_progress
  end

  def get_number_correct
    GeneralUserPerformance.new(@q_ids[@current_question], self).get_number_correct
  end

  def get_next_badge
    ProgressBar.new(@user_progress.user_specialty_points,
                    @user_progress.next_badge_points, self).
                    next_badge(Badge.new(user_id: current_user,
                    specialty_id: @question.video.specialty.id,
                    level: @user_progress.next_badge))
  end

  def show_answer(answer_number)
    answer = "answer_#{answer_number}"
    if @question.correct_answer == answer_number
      content_tag :div, class:"default_lecture_question correct_lecture_answer" do
        content_tag(:p, @question.send(answer), class:"lecture_questions_list_left_column")+
        content_tag(:p, 'Correct', class:"lecture_question_status_icon")
      end
    else
      content_tag :div, class:"default_lecture_question incorrect_lecture_answer" do
        content_tag(:p, @question.send(answer), class:"lecture_questions_list_left_column")+
        content_tag(:p, 'Incorrect', class:"lecture_question_status_icon")
      end
    end
  end

end