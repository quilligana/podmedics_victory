class ProgressBar

  def initialize(current_question, total_questions, template)
    @template = template
    @current_question = current_question
    @total_questions = total_questions
  end

  def test_progress
    content_tag(:div, content_tag(:div, '', class: progress_bar_class), 
                class: "questions_placement_bar") +
    content_tag(:p, "Question #{@current_question} of #{@total_questions}")
  end

  private
  
    def progress_bar_class
      "active_placement_bar #{percentage_complete}_percent"
    end

    def percentage_complete
      complete = 10*((10*@current_question/@total_questions).round)
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

    def method_missing(*args, &block)
      @template.send(*args, &block)
    end

end