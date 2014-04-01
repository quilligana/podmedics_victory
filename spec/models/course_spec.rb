require 'spec_helper'

describe Course do
  it { should validate_presence_of :title }
  it { should validate_presence_of :date }
  it { should validate_presence_of :price }
  it { should validate_presence_of :description }
  it { should validate_presence_of :event_link }
end
