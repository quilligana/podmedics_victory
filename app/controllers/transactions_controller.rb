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
        flash.now[:alert] = sale.error
        render :new
      end
    end
  end

  def pickup
  end

end
