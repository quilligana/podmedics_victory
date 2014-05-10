class QuestionResults
  attr_reader :total_count, :correct_count, :ratio

  def initialize(user_questions, total_questions)
   @total_count = total_questions
   @correct_count = user_questions.where(correct_answer: true).count
   @ratio = @correct_count / total_questions
  end

  def bad_result?
    if @ratio < PASS_GRADE / 100
      true
    else
      false
    end
  end

  def top_result?
    if @ratio == 1
      true
    else
      false
    end
  end
     
end 