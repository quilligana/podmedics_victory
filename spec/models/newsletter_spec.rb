require 'spec_helper'

describe Newsletter do

  it { should validate_presence_of :subject}
  it { should validate_presence_of :body_content }
  it { should validate_presence_of :body_text }

end
