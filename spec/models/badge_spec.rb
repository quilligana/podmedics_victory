require 'spec_helper'

describe Badge do

  let(:user) { FactoryGirl.create(:user) }
  let(:specialty) { FactoryGirl.create(:specialty) }
  before do
    @badge = user.badges.build(specialty_id: specialty.id, level: 'Medical Student')
  end

  subject { @badge }

  it { should respond_to :user_id }
  it { should respond_to :specialty_id }
  it { should respond_to :level }

  it { should respond_to :user }
  its(:user) { should eq user }
  it { should respond_to :specialty }
  its(:specialty) { should eq specialty }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @badge.user_id = nil }
    it { should_not be_valid }
  end

  describe "when specialty_id is not present" do
    before { @badge.specialty_id = nil }
    it { should_not be_valid }
  end

end
