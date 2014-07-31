# == Schema Information
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  member_only :boolean          default(FALSE)
#

require 'spec_helper'

describe Faq do

  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  
  it { should respond_to :member_only }

  it "has a valid factory for normal faqs" do
    expect(build(:faq)).to be_valid
  end

  it "has a valid factory for member only faqs" do
    expect(build(:member_faq)).to be_valid
  end

  describe Faq, '.for_members' do
    it "filters member only faqs" do
      public_faq = create(:faq)
      member_faq = create(:member_faq)
      expect(Faq.for_members).to_not include public_faq
    end
  end

end
