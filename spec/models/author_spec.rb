require 'spec_helper'

describe Author do

  it { should have_many :videos }

  it { should validate_presence_of :name }
  it { should validate_presence_of :tagline }
  it { should respond_to :twitter }
  it { should respond_to :facebook }

  it "has a valid factory" do
    expect(build(:author)).to be_valid
  end

end
