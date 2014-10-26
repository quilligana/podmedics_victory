class TransactionsController < ApplicationController
  layout 'user_application'

  def new
    @free_product = Product.where(permalink: 'free').first
    @paid_6 = Product.where(permalink: 'paid6').first
    @paid_12 = Product.where(permalink: 'paid12').first
  end

  def create
    product = Product.find_by_permalink(params[:permalink])

    if product.free?
      current_user.mark_plan_selected
      UserMailer.delay.welcome_free_plan(current_user)
      redirect_to dashboard_path, notice: 'Thank you for signing up for our trial.'
    else
      sale = product.sales.create(
        amount: product.price,
        email: params[:stripeEmail],
        stripe_token: params[:stripeToken],
        user_id: current_user.id
      )
      sale.process!
      if sale.finished?
        current_user.start_subscription_for_product(product)
        redirect_to pickup_url(guid: sale.guid)
      else
        AdminMailer.delay.payment_failed(current_user)
        flash.now[:alert] = sale.error
        render :new
      end
    end
  end

  def receive_paypal
    user_id = params[:cm]
    product_id = params[:item_number]
    status = params[:st]
    amount = params[:amt]
    transaction_id = params[:tx]

    sale = Sale.new
    sale.receive_paypal_callback(user_id, product_id)
    redirect_to pickup_url(user_id: current_user.id, guid: sale.guid)
  end

  # endpoint after Stripe or Paypal sale
  def pickup
  end

  # cancel the transaction before trying it
  # i.e. the user has seen the payment page and does not
  # wish to proceed
  def cancel_transaction
    # logout the user
    logout
    redirect_to root_path, notice: 'Thanks. We hope you change your mind and come back'
  end

end
