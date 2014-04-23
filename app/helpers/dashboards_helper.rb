module DashboardsHelper

  def badge_award_time(badge)
    content_tag(:p, "<strong>#{time_ago_in_words(badge.created_at)}</strong> ago you were awarded".html_safe, class: "badge_earned_date")
  end

  def show_lecture_icons(video)
    LectureIcons.new(video, current_user, self).show_lecture_icons
  end

private

  def badge_class(level)
    level.gsub(/ /, '_').downcase
  end
end