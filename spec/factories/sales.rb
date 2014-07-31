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

FactoryGirl.define do
  factory :sale do
    email "test@example.com"
    guid "randomgeneratedstring"
    association :product
  end
end
