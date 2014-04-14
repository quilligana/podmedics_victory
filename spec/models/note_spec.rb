require 'spec_helper'

describe Note do

  it { should belong_to :user }
  it { should belong_to :specialty }
  it { should belong_to :video }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }

end
