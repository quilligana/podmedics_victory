# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  comment_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base

  belongs_to :user, touch: true
  belongs_to :comment, touch: true

  # Caching functions

  def cached_user
    User.cached_find(user_id)
  end

end
