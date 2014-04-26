class QuestionResults
  attr_reader :total_count, :correct_count, :ratio

  def initialize(questions)
   @total_count = questions.count
   @correct_count = questions.where(correct_answer: true).count
   @ratio = @correct_count / @total_count
  end

  def bad_result?
    if 100 * @ratio < PASS_GRADE
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