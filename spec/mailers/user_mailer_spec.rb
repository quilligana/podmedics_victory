require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) { create(:user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "send user password reset url" do
      mail.subject.should eq("Podmedics Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@podmedics.com"])
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end

  describe "badge_award" do
    let(:user) { create(:user) }
    let(:badge) { create(:badge) }
    let(:mail) { UserMailer.badge_award(user, badge) }

    it "notifies the user of their new badge" do
      mail.subject.should eq("Congratulations on Your New Podmedics Badge Award")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@podmedics.com"])
      mail.body.should have_content(badge.level)
      mail.body.should have_content(badge.specialty.name)
    end
  end

  describe "professor_loss" do
    let(:user) { create(:user) }
    let(:specialty) { create(:specialty) }
    let(:mail) { UserMailer.professor_loss(user, specialty) }

    it "notifies the user of their loss of professor badge" do
      mail.subject.should eq("Notification of Your Professor Status")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@podmedics.com"])
      mail.body.should have_content(specialty.name)
    end
  end
end
