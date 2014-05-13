module ApplicationHelper

  def nav_link(text, url)
    link_class = nil
    if current_page? url
      link_class = 'selected'
    end

    link_to text, url, class: link_class
  end

  def user_points
    content_tag(:p, "#{@current_user.points} <span>Total Points</span>".html_safe, class: "questions_info_right_column_number")
  end

  def user_specialty_points(user_progress, specialty)
    content_tag(:p, "#{user_progress.user_specialty_points} <span>#{specialty.name} Points</span>".html_safe, class: 'questions_info_right_column_number')
  end

  def exams_passed
    content_tag(:p, current_user.exams.where("percentage > ?", PASS_GRADE).count,
                class:"number")
  end

  def to_underscored(string)
    string.downcase.tr(" ", "_")
  end

  def show_specialty_badge(specialty)
    if current_user.badges.where(specialty_id: specialty.id).any?
      badge = current_user.badges.where(specialty_id: specialty.id).last
      show_badge(badge)
    end
  end

  def show_badge(badge)
    content_tag :a, class: "badge" do
      content_tag(:p, badge.level, class: "badge_title #{badge_class(badge.level)}") +
      content_tag(:p, + 1, class: "badge_speciality small_screen_count") +
      content_tag(:p, badge.specialty.name, class: "badge_speciality")
    end
  end

end
