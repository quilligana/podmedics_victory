# == Schema Information
#
# Table name: stripe_events
#
#  id          :integer          not null, primary key
#  stripe_id   :string(255)
#  stripe_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe StripeEvent do
  it { should validate_uniqueness_of :stripe_id }
end
