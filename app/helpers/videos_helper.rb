module VideosHelper

  def questions_exist
    @video.cached_questions_count > 0
  end

  def tag_list(tags)
    tags.each do |tag|
      link_to '#', class: 'tag' do
        content_tag(:span, tag.name)
      end
    end
  end

end
