require 'spec_helper'

describe Product do

  it { should validate_presence_of :name }
  it { should validate_presence_of :price }

  describe Product, '#free?' do
    it "should return true if price is 0" do
      free_product = create(:free_product)
      expect(free_product.free?).to be_true
    end

    it "should return false if the price is greater than 0" do
      paid_product = create(:paid_product)
      expect(paid_product.free?).to be_false
    end
  end

  describe Product, '#paid?' do
    it "should return true if price is greater than 0" do
      paid_product = create(:paid_product)
      expect(paid_product.paid?).to be_true
    end

    it "should return false if price is not greater than 0" do
      free_product = create(:free_product)
      expect(free_product.paid?).to be_false
    end
  end

end
