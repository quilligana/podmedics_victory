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
      redirect_to dashboard_path, notice: 'Thanks for signing up for our trial'
    else
      token = params[:stripeToken]

      begin
        charge = Stripe::Charge.create(
          amount: product.price,
          currency: "gbp",
          card: token,
          description: params[:stripeEmail]
        )

        @sale = product.sales.create!(
          email: params[:stripeEmail]
        )

        sign_in_user(@user)
        redirect_to pickup_url(guid: @sale.guid)
      rescue Stripe::CardError => e
        @error = e
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
