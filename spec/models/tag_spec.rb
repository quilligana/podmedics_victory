require 'spec_helper'

describe Tag do

  it { should have_many :taggings}
  it { should have_many(:videos).through(:taggings) }

end
