require 'spec_helper'

describe StripeEvent do
  it { should validate_uniqueness_of :stripe_id }
end
