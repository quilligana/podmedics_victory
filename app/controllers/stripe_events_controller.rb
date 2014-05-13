class StripeEventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :parse_and_validate_event

  def create
    if self.class.private_method_defined? event_method
      self.send(event_method, @event.event_object)
    end
    render nothing: true
  end

  private

  def event_method
    "stripe_#{@event.stripe_type.gsub('.', '_')}".to_sym
  end

  def parse_and_validate_event
    @event = StripeEvent.new(stripe_id: params[:id], stripe_type: params[:type])

    unless @event.save
      if @event.valid?
        render nothing: true, status: 400 # valid event, try again later
      else
        render nothing: true # invalid event, move along
      end
    end
  end

  def stripe_charge_dispute_created(charge)
    StripeMailer.delay.admin_dispute_created(charge)
  end

  def stripe_charge_succeeded(charge)
    StripeMailer.delay.user_receipt(charge)
    StripeMailer.delay.admin_charge_succeeded(charge)
  end

end
