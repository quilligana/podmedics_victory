require 'spec_helper'

describe Post do

  it { should belong_to :author }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }

end
