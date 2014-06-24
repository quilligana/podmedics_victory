class Vote < ActiveRecord::Base

  belongs_to :user, touch: true
  belongs_to :comment, touch: true

  # Caching functions

  def cached_user
    User.cached_find(user_id)
  end

end
