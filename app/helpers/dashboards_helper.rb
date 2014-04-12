module DashboardsHelper

  def show_badge(badge)
    content_tag :a, class: "badge" do
      content_tag(:p, badge.level, class: "badge_title #{badge_class(badge.level)}")+
      content_tag(:p, + 1, class: "badge_speciality small_screen_count")+
      content_tag(:p, badge.specialty.name, class: "badge_speciality")
    end
  end

private

  def badge_class(level)
    level.gsub(/ /, '_').downcase
  end
end