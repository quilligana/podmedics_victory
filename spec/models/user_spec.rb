require 'spec_helper'

describe User do

  it { should have_secure_password }
  it { should validate_presence_of :name }
  it { should validate_presence_of :password}
  it { should respond_to :points }
  it { should respond_to :user_questions }
  it { should respond_to :badges }

  it { should have_many(:user_questions).dependent(:destroy) }
  it { should have_many(:vimeos).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:specialty_questions).dependent(:destroy) }
  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:notes).dependent(:destroy) }
  it { should have_many :sales }

  it { should have_attached_file(:avatar) }
  it { should validate_attachment_content_type(:avatar).
        allowing('image/png', 'image/gif', 'image/jpg', 'image/jpeg').
        rejecting('text/plain', 'text/xml', 'video/mov') }
  it { should validate_attachment_size(:avatar).less_than(500.kilobytes) }

  it 'should have a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'should have a valid factory for an admin user' do
    expect(build(:admin_user)).to be_valid
    expect(build(:admin_user)).to be_admin
  end

  it "validates format of email" do
   expect(build(:user, email: 'bad')).to_not be_valid
  end

  describe User, 'password validation' do
    it "not accept a 4 character password" do
      user = build(:user, password: 'aaaa', password_confirmation: 'aaaa')
      expect(user).to_not be_valid
    end

    it "does not accept a 35 character password" do
      long_password = SecureRandom.hex(35)
      user = build(:user, password: long_password, password_confirmation: long_password)
      expect(user).to_not be_valid
    end

  end

  describe User, '#add_points_for_answer' do
    it "adds the points per correct answer to the points total" do
      user = create(:user)
      expect(user.points).to eq(0)
      user.add_points_for_answer
      expect(user.points).to eq(POINTS_PER_CORRECT_ANSWER)
    end
  end

  describe User, '#send_password_reset' do
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

  describe User, '#mark_plan_selected' do
    it "marks the user as having selected a plan" do
      user = create(:user)
      user.mark_plan_selected
      expect(user.selected_plan).to be_true
    end
  end

  describe User, '#start_subscription' do
    it "sets the subscribed_on attribute" do
      user = create(:user)
      user.start_subscription
      expect(user.subscribed_on).to_not be_nil
    end
  end

  describe User, '#expires_on' do
    it "return 1 year after the subscribed_on date" do
      user = create(:user)
      user.start_subscription
      expect(user.expires_on).to eq (user.subscribed_on + 1.year)
    end
  end

  describe User, '#has_selected_plan?' do
    it "returns true if an admin" do
      admin = create(:admin_user)
      expect(admin.has_selected_plan?).to be_true
    end

    it "returns true if user subscribed and in date" do
      user = create(:user, subscribed_on: Time.zone.now)
      expect(user.has_selected_plan?).to be_true
    end

    it "returns false if user has not selected a plan" do
      user = create(:user, selected_plan: false )
      expect(user.has_selected_plan?).to be_false
    end

    it "returns true if user has selected a plan but not susbcribed" do
      user = create(:user, subscribed_on: nil)
      expect(user.has_selected_plan?).to be_true
    end
  end

  describe User, '#has_subscription_and_in_date?' do
    it "return false be default" do
      user = create(:user, subscribed_on: nil)
      expect(user.has_subscription_and_in_date?).to be_false
    end
    it "returns true if subscription in date" do
      user = create(:user, subscribed_on: Time.zone.now)
      expect(user.has_subscription_and_in_date?).to be_true
    end
  end

  describe User, '#for_walkthrough?' do
    it "returns false if user has a login count > 1" do
      user = create(:user, login_count: 10)
      expect(user.for_walkthrough?).to be_false
    end

    it "returns true on first login" do
      user = create(:user, login_count: 1)
      expect(user.for_walkthrough?).to be_true
    end
  end

  describe User, '#unsubscribe' do
    it "unsubscribes from all emails" do
      user = create(:user)
      user.unsubscribe
      user.reload
      expect(user.receive_newsletters).to be_false
      expect(user.receive_new_episode_notifications).to be_false
      expect(user.receive_reply_notifications).to be_false
      expect(user.receive_social_notifications).to be_false
    end
  end

end
