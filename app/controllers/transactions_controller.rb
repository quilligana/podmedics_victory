class TransactionsController < ApplicationController
  before_action :find_user

  def new
    @free_product = Product.where(permalink: 'free').first
    @paid_product = Product.where(permalink: 'paid').first
  end

  def create
    product = Product.find_by_permalink(params[:permalink])

    if product.free?
      @user.mark_plan_selected
      sign_in_user(@user)
      redirect_to dashboard_path, notice: 'Thank you  for signing up for our trial.'
    else
      sale = product.sales.create(
        amount: product.price,
        email: params[:stripeEmail],
        stripe_token: params[:stripeToken]
      )
      sale.process!
      if sale.finished?
        sign_in_user(@user)
        redirect_to pickup_url(guid: sale.guid)
      else
        flash.now[:alert] = sale.error
        render :new
      end
    end
  end

  def pickup
  end

  private

    def find_user
      @user = User.cached_find(params[:user_id])
    end

    def sign_in_user(user)
      session[:user_id] = @user.id
    end

end
