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

    describe "when the user has unsubscribed" do
      before do
        user.unsubscribe
        @mail = UserMailer.password_reset(user)
      end

      it "will still send the email" do
        @mail.subject.should eq("Podmedics Password Reset")
        @mail.to.should eq([user.email])
        @mail.from.should eq(["admin@podmedics.com"])
        @mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
      end
    end
  end

  describe "badge_award" do
    let(:user) { create(:user) }
    let(:specialty) { create(:specialty)}
    let(:badge) { create(:badge, specialty: specialty, level: 'Student') }
    let(:mail) { UserMailer.badge_award(user, badge) }

    it "notifies the user of their new badge" do
      mail.subject.should eq("Congratulations on Your New Podmedics Badge Award")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@podmedics.com"])
    end

    describe "when the user has unsubscribed" do
      before do
        user.unsubscribe
        @mail = UserMailer.badge_award(user, badge)
      end

      it "will not send the email" do
        @mail.subject.should eq nil
      end
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
    end

    describe "when the user has unsubscribed" do
      before do
        user.unsubscribe
        @mail = UserMailer.professor_loss(user, specialty)
      end

      it "will not send the email" do
        @mail.subject.should eq nil
      end
    end
  end

  describe "new_episode" do
    let(:user) { create(:user) }
    let(:video) { create(:video) }
    let(:mail) { UserMailer.new_episode(user, video) }

    it "notifies the user of their loss of professor badge" do
      mail.subject.should eq("There is a new video: #{video.title}")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@podmedics.com"])
    end

    describe "when the user has unsubscribed" do
      before do
        user.unsubscribe
        @mail = UserMailer.new_episode(user, video)
      end

      it "will not send the email" do
        @mail.subject.should eq nil
      end
    end
  end

  describe "new_reply" do
    let(:user) { create(:user) }
    let(:video) { create(:video) }
    let(:comment) { create(:comment, commentable: video, root: video) }
    let(:reply) { create(:comment, commentable: comment, root: video) }
    let(:mail) { UserMailer.new_reply(user, comment, reply) }

    it "notifies the user of their loss of professor badge" do
      mail.subject.should eq("You have a new reply")
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@podmedics.com"])
    end

    describe "when the user has unsubscribed" do
      before do
        user.unsubscribe
        @mail = UserMailer.new_reply(user, comment, reply)
      end

      it "will not send the email" do
        @mail.subject.should eq nil
      end
    end
  end

  describe "answer_accepted" do
    let(:user) { create(:user) }
    let(:specialty_question) { create(:specialty_question) }
    let(:answer) { create(:comment, commentable: specialty_question, root: specialty_question) }
    let(:mail) { UserMailer.answer_accepted(user, answer) }

    it "notifies the user of their loss of professor badge" do
      mail.subject.should eq('One of your answers has been accepted')
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@podmedics.com"])
    end

    describe "when the user has unsubscribed" do
      before do
        user.unsubscribe
        @mail = UserMailer.answer_accepted(user, answer)
      end

      it "will not send the email" do
        @mail.subject.should eq nil
      end
    end
  end

  describe 'new_episode' do
    let(:user) { create(:user)}
    let(:video) { create(:video)}
    let(:mail) { UserMailer.new_episode(user, video) }

    it "notifies the user of the new episode" do
      mail.subject.should eq "New Podmedics Video: #{video.title}"
      mail.to.should eq([user.email])
      mail.from.should eq(["admin@podmedics.com"])
    end
  end

end
