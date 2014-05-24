module Commentable

  # Caching functions

  def cached_comments(include_hidden = false)
    Rails.cache.fetch([self, include_hidden, "comments"]) { get_comments(include_hidden).to_a }
  end

  def cached_comments_count(include_hidden = false)
    Rails.cache.fetch([self, include_hidden, "comments_count"]) { comments_count(include_hidden) }
  end

  # Comment functions

  def comments_count(include_hidden = false)
    only_available(include_hidden, nested_comments).size
  end
  
  def get_comments(include_hidden = false)
    only_available(include_hidden, comments).sort_by(&:score).reverse
  end

  private

    def only_available(include_hidden, comments)
      include_hidden ? comments : comments.available
    end

end
