class Quiz

  attr_reader :current_question, :question_number, :question_ids, :number_correct

  def initialize(session)
    @question_number = session[:current_question]
    @question_ids = session[:q_ids]
    @current_question = get_current_question
    @number_correct = session[:correct_answers]
  end

  def get_current_question
    question_id = @question_ids[@question_number-1]
    Question.find(question_id)
  end

  def get_current_id
    @question_ids[@question_number-1]
  end

  def video
    @current_question.video
  end

  def correct_answer
    @current_question.get_correct_answer
  end

  def total_questions
    @question_ids.length
  end

  def next_question
    if self.active?
      question_id = @question_ids[@question_number]
      Question.find(question_id)
    end
  end

  def active?
    if @question_number < self.total_questions
      true
    else
      false
    end
  end

end