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

  def self.income_last_month
    sales = Sale.where(created_at: 1.month.ago..Time.zone.now)
    calculate_income(sales)
  end

  def self.income_last_week
    sales = Sale.where(created_at: 1.week.ago..Time.zone.now)
    calculate_income(sales)
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
    user.start_subscription_for_product(product, self)
  end

  def receipt
    Receipts::Receipt.new(
      id: id,
      product: "Podmedics",
      company: {
        name: "Podmedics Limited",
        address: "Unit 118, Basepoint Business Centre, Eastcote, HA4 9NA",
        email: "contact@podmedics.com",
        logo: Rails.root.join("app/assets/images/podmedics_home_icon.png")
      },
      line_items: [
        ["Date", created_at.strftime("%B %d, %Y")],
        ["Account billed", "#{user.name} - #{user.email}"],
        ["Product", product.name],
        ["Cost", "£#{(actual_cost / 100).round(2)}"],
        ["VAT (20%)", "£#{(calculate_vat_amount / 100).round(2)}"],
        ["Total", "£#{amount / 100}.00"],
        ["Transaction ID", "##{id}"]
      ]
    )
  end

  private

    # note: this assumes VAT is 20%
    def actual_cost
      (amount / 1.2)
    end

    def calculate_vat_amount
      (amount - actual_cost)
    end
    
    def self.calculate_income(sales)
      income = 0
      sales.each do |s|
        income += s.amount
      end
      income/100
    end

    def populate_guid
      self.guid = SecureRandom.uuid()
    end

end
