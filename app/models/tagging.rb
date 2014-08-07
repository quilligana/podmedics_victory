# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  video_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Tagging < ActiveRecord::Base

  belongs_to :tag, touch: true
  belongs_to :video, touch: true

end
