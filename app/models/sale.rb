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

class Sale < ActiveRecord::Base
  include AASM
  has_paper_trail

  belongs_to :product
  before_create :populate_guid
  belongs_to :user

  aasm column: 'state' do
    state :pending, initial: true
    state :processing
    state :finished
    state :errored

    event :process, after: :charge_card do
      transitions from: :pending, to: :processing
    end

    event :finish do
      transitions from: :processing, to: :finished
    end

    event :fail do
      transitions from: :processing, to: :errored
    end
  end

  def charge_card
    begin
      save!
      charge = Stripe::Charge.create(
        amount: self.amount,
        currency: 'gbp',
        card: self.stripe_token,
        description: self.email
      )
      balance = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)
      self.update(
        stripe_id: charge.id,
        card_expiration: Date.new(charge.card.exp_year, charge.card.exp_month, 1),
        fee_amount: balance.fee
      )
      self.finish!
    rescue Stripe::StripeError => e
      self.update_attributes(error: e.message)
      self.fail!
    end
  end

  def receive_paypal_callback(user_id, product_id)
    user = User.find(user_id)
    product = Product.find(product_id)
    self.update(
      user_id:  user.id,
      product_id: product.id,
      email: user.email,
      fee_amount: product.price,
      amount: product.price,
      state: 'finished'
    )
    user.start_subscription_for_product(product)
  end

  private

    def populate_guid
      self.guid = SecureRandom.uuid()
    end

end
