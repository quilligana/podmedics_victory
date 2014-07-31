# == Schema Information
#
# Table name: sales
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  guid            :string(255)
#  product_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  state           :string(255)
#  stripe_id       :string(255)
#  stripe_token    :string(255)
#  card_expiration :date
#  error           :text
#  fee_amount      :integer
#  amount          :integer
#  user_id         :integer
#

require 'spec_helper'

describe Sale do

  it { should belong_to :product }
  it { should belong_to :user }

  it "has valid factory" do
    expect(build(:sale)).to be_valid
  end

  it "populates a guide before creating" do
    sale = create(:sale)
    expect(sale.guid).to_not be_nil
  end

end
