require 'spec_helper'

describe Badge do

  it { should belong_to :user}
  it { should belong_to :specialty}

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :specialty_id }
  it { should validate_presence_of :level }

end
