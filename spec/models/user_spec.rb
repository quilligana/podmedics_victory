require 'spec_helper'

describe User do

  it { should have_secure_password }
  it { should validate_presence_of :email }

  it 'should have a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'should have a valid factory for an admin user' do
    expect(build(:admin_user)).to be_valid
    expect(build(:admin_user)).to be_admin
  end

end
