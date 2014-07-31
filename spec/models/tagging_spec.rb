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

require 'spec_helper'

describe Tagging do

  it { should belong_to :tag}
  it { should belong_to :video}

end
