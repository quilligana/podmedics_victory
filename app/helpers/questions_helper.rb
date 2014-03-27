module QuestionsHelper

  def test_progress
    content_tag(:div, content_tag(:div, '', class: progress_bar_class), class: "questions_placement_bar")
  end

  def progress_bar_class
    question_id_array = session[:q_ids]
    total_questions = question_id_array.length
    current_question = session[:current_question]
    "active_placement_bar #{percentage_complete(current_question, total_questions)}_percent"
  end

  def percentage_complete(current_question, total_questions)
    complete = 10*((10*current_question/total_questions).round)
    case complete
    when 0
      "zero"
    when 10
      "ten"
    when 20
      "twenty"
    when 30
      "thirty"
    when 40
      "forty"
    when 50
      "fifty"
    when 60
      "sixty"
    when 70
      "seventy"
    when 80
      "eighty"
    when 90
      "ninety"
    when 100
      "hundred"
    end        
  end

end
