module ApplicationHelper

  def nav_link(text, url)
    link_class = nil
    if current_page? url
      link_class = 'selected'
    end

    link_to text, url, class: link_class
  end

end
