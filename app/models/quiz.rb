class Quiz

  attr_reader :current_question, :question_number, :correct_answer_number, :question_ids, :number_correct

  def initialize(session)
    @question_number = session[:current_question]
    @question_ids = session[:q_ids]
    @current_question = get_current_question
    @correct_answer_number = @current_question.correct_answer
    @number_correct = session[:correct_answers]
  end

  def get_current_question
    question_id = @question_ids[@question_number-1]
    Question.find(question_id)
  end

  def get_current_id
    @question_ids[@question_number-1]
  end

  def answered_correct?(answer)
    true if answer == @correct_answer_number
  end

  def video
    @current_question.video
  end

  def current_answer(answer)
    @current_question.get_answer(answer)
  end

  def correct_answer
    @current_question.get_answer(@current_question.correct_answer)
  end

  def total_questions
    @question_ids.length
  end

  def next_question
    if active?
      question_id = @question_ids[@question_number]
      Question.find(question_id)
    end
  end

  def record_answer(user, answer)
    if answered_correct?(answer)
      UserQuestion.save_answer(get_current_id, user, answer)
    end
  end

  def active?
    if @question_number < total_questions
      true
    else
      false
    end
  end

end