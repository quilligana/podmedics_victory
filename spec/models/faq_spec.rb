require 'spec_helper'

describe Faq do

  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
end
