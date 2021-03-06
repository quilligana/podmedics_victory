# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Tag do

  it { should have_many :taggings}
  it { should have_many(:videos).through(:taggings) }

end
