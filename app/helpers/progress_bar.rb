class ProgressBar

  def initialize(current_value, target_value, template)
    @template = template
    @current_value = current_value
    @target_value = target_value
  end

  def test_progress
    content_tag(:div, content_tag(:div, '', class: progress_bar_class), 
                class: "questions_placement_bar") +
    content_tag(:p, "Question #{@current_value} of #{@target_value}")
  end

  def next_badge(badge)
    content_tag(:div, content_tag(:div, '', class: progress_bar_class), 
                class: "questions_placement_bar") +
    content_tag(:div, "You are just #{ @target_value - @current_value } points away from becoming a:", 
                class: "points_away_title") +
    show_badge(badge)
  end

  private
  
    def progress_bar_class
      "active_placement_bar #{percentage_complete}_percent"
    end

    def percentage_complete
      complete = 10*((10*@current_value/@target_value).round)
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