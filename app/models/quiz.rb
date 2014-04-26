class Quiz

  attr_reader :current_question, :question_number, :question_ids, :number_correct

  def initialize(params, session)
    @current_question = Question.find(params[:id])
    @question_number = session[:current_question]
    @question_ids = session[:q_ids]
    @number_correct = session[:correct_answers]
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

end