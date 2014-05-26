require 'spec_helper'

describe AdminMailer do

  describe 'new_specialty_question' do
    let(:specialty) { create(:specialty) }
    let(:mail) { AdminMailer.new_specialty_question(specialty)}

    it "notifies ed@podmedics.com" do
      mail.subject.should eq "New Specialty Question"
      mail.to.should eq ["ed@podmedics.com"]
      mail.from.should eq ["donotreply@podmedics.com"]
    end
  end

  describe 'new_comment' do
    let(:comment) { create(:comment)}
    let(:mail) { AdminMailer.new_comment(comment)}

    it "notifies ed@podmedics.com" do
      mail.subject.should eq "New Comment"
      mail.to.should eq ["ed@podmedics.com"]
      mail.from.should eq ["donotreply@podmedics.com"]
    end
  end

  describe '#test_newsletter' do
    before do
      create(:user)
    end

    let(:newsletter) { create(:newsletter) }
    let(:mail) { AdminMailer.test_newsletter(newsletter)}

    it "send a sample newsletter to ed" do
      mail.subject.should eq newsletter.subject
      mail.to.should eq ['ed@podmedics.com']
      mail.from.should eq ["donotreply@podmedics.com"]
    end
  end

end
