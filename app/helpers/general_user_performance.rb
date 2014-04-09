class GeneralUserPerformance
  
  def initialize(q_id, template)
    @q_id = q_id
    @template = template
  end

  def get_number_correct
    content_tag(:p, percentage, class: "questions_info_right_column_number") +
    content_tag(:p, "Of users answered this question correctly.")
  end

  private

    def percentage
      UserQuestion.percent_who_got_correct(@q_id)
    end

    def method_missing(*args, &block)
      @template.send(*args, &block)
    end

end