require 'spec_helper'

describe Vimeo do
  it { should respond_to :user_id }
  it { should respond_to :video_id }
  it { should respond_to :progress }
  it { should respond_to :completed }
  it { should belong_to :user }
  it { should belong_to :video }
end
