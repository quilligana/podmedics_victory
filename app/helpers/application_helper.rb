module ApplicationHelper

  def nav_link(text, url)
    link_class = nil
    if current_page? url
      link_class = 'selected'
    end

    link_to text, url, class: link_class
  end

  def user_points
    content_tag(:p, "#{@current_user.points} <span>Total Points</span>".html_safe, class: "questions_info_right_column_number") +
    content_tag(:p, "For every video watched or correct answer you will receive #{POINTS_PER_CORRECT_ANSWER} points to your overall score.")
  end

  def to_underscored(string)
    string.downcase.tr(" ", "_")
  end

  def show_badge(badge)
    content_tag :a, class: "badge" do
      content_tag(:p, badge.level, class: "badge_title #{badge_class(badge.level)}")+
      content_tag(:p, + 1, class: "badge_speciality small_screen_count")+
      content_tag(:p, badge.specialty.name, class: "badge_speciality")
    end
  end

end
