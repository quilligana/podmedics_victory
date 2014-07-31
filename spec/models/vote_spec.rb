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

require 'spec_helper'

describe Vote do

  it { should belong_to :user }
  it { should belong_to :comment }

end
