require 'spec_helper'

describe UserQuestion do
  
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should belong_to :user }

end
