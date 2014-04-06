module DashboardsHelper

  def badge_class(level)
    level.gsub(/ /, '_').downcase
  end
end
