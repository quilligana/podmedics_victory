class TransactionsController < ApplicationController

  def new
    @free_product = Product.where(permalink: 'free').first
    @paid_product = Product.where(permalink: 'paid').first
  end

  def create
    product = Product.find_by_permalink(params[:permalink])
    if product.free?
      redirect_to dashboard_path, notice: 'Thanks for signing up for our trial'
    end

  end

  def pickup
  end

end
