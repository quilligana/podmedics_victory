class GeneralUserPerformance
  
  def initialize(q_ids, number_incorrect, template)
    @q_ids = q_ids
    @number_incorrect = number_incorrect
    @template = template
  end

  def get_swots
    content_tag(:p, percentage, class: "questions_info_right_column_number") +
    content_tag(:p, "Of users who took this test scrored on average #{fraction} questions correct.")
  end

  private

    def percentage
      UserQuestion.percent_who_got_wrong(@q_ids, @number_incorrect)
    end

    def fraction
      case @number_incorrect
      when 0
        "#{@q_ids.length}/#{@q_ids.length}"
      when 1
        "#{@q_ids.length-1}/#{@q_ids.length}"
      end
    end

    def method_missing(*args, &block)
      @template.send(*args, &block)
    end

end