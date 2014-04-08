require 'spec_helper'

describe User do

  it { should have_secure_password }
  it { should validate_presence_of :email }
  it { should validate_presence_of :name }
  it { should respond_to :points }
  it { should respond_to :user_questions }
  it { should respond_to :badges }

  it 'should have a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'should have a valid factory for an admin user' do
    expect(build(:admin_user)).to be_valid
    expect(build(:admin_user)).to be_admin
  end

  it "validates format of email" do
   bad_email_user = build(:user, email: 'bad') 
   expect(bad_email_user).to_not be_valid
  end

  it 'has an add_points method' do
    user = create(:user)
    expect(user.points).to eq(0)
    user.add_points_for_answer
    expect(user.points).to eq(POINTS_PER_CORRECT_ANSWER)
  end

  describe '#send_password_reset' do
    let(:user) { create(:user) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end
end
