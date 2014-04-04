module ApplicationHelper

  def nav_link(text, url)
    link_class = nil
    if current_page? url
      link_class = 'selected'
    end

    link_to text, url, class: link_class
  end

  def user_points
    content_tag(:p, "#{@current_user.points} <span>Points</span>".html_safe, class: "questions_info_right_column_number") +
    content_tag(:p, "For every video watched or correct answer you will receive #{POINTS_PER_CORRECT_ANSWER} points to your overall score.")
  end

  def to_underscored(string)
    string.downcase.tr(" ", "_")
  end

end
