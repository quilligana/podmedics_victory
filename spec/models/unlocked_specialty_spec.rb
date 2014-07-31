# == Schema Information
#
# Table name: unlocked_specialties
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  specialty_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe UnlockedSpecialty do

  it { should belong_to :user}
  it { should belong_to :specialty}
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

end
