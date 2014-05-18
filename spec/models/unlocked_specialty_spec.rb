require 'spec_helper'

describe UnlockedSpecialty do

  it { should belong_to :user}
  it { should belong_to :specialty}
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

end
