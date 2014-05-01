require 'spec_helper'

describe Sale do

  it { should belong_to :product }

  it "has valid factory" do
    expect(build(:sale)).to be_valid
  end

  it "populates a guide before creating" do
    sale = create(:sale)
    expect(sale.guid).to_not be_nil
  end

end
