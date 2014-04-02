require 'spec_helper'

describe Faq do

  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  
  it { should respond_to :member_only }

  it "has a valid factory for member only faqs" do
    expect(build(:member_faq)).to be_valid
  end

  it "filters member only faqs" do
    public_faq = create(:faq)
    member_faq = create(:member_faq)
    expect(Faq.for_members).to_not include public_faq
  end
end
