class StripeMailer < ActionMailer::Base
  default from: 'ed@podmedics.com'

  def admin_dispute_created(charge)
    @charge = charge
    @sale = Sale.find_by(stripe_id: @charge.id)
    if @sale
      mail(to: 'ed@podmedics.com', subject: "Dispute created on charge #{@sale.guid} (#{charge.id})").deliver
    end
  end

  def admin_charge_succeeded(charge)
    @charge = charge
    @sale = Sale.find_by(stripe_id: @charge.id)
    if @sale
      mail(to: 'ed@podmedics.com', subject: 'Woo! Charge Succeeded')
    end
  end

  def user_receipt(charge)
    @charge = charge
    @sale = Sale.find_by(stripe_id: @charge.id)
    if @sale
      html = render_to_string('stripe_mailer/user_receipt.html')

      pdf = Docverter::Conversion.run do |c|
        c.from = 'html'
        c.to = 'pdf'
        c.content = 'html'
      end

      attachment['receipt.pdf'] = pdf
      mail(to: sale.email, subject: 'Your Podmedics Receipt')
    end
  end

end
