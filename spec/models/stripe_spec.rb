require 'spec_helper'
require 'stripe_mock'

describe 'StripeMock' do
  before { StripeMock.start }
  after { StripeMock.stop }


  it "creates a stripe customer" do
    customer = Stripe::Customer.create({
      email: 'test@example.com',
      card: 'void_card_token'
    })
    expect(customer.email).to eq('test@example.com')
  end

  it "mocks a declined card error" do
    StripeMock.prepare_card_error(:card_declined)

    expect { Stripe::Charge.create }.to raise_error { |e|
      expect(e).to be_a Stripe::CardError
      expect(e.http_status).to eq(402)
      expect(e.code).to eq('card_declined')
    }
  end

  it "mocks a stripe webhook" do
    event = StripeMock.mock_webhook_event('customer.created')

    customer_object = event.data.object
    expect(customer_object.id).to_not be_nil
    expect(customer_object.default_card).to_not be_nil
  end
  
end
