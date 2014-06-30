class Paypal
  
  def initialize(product, user, return_url)
    @product = product
    @user = user
    @return_url = return_url
  end

  def generate_url
    values = {
      business: "ed@podmedics.co.uk",
      cmd: '_xclick',
      return: @return_url,
      custom: @user.id,
      invoice: Time.now,
      currency_code: 'GBP',
      amount: 0.01,
      no_shipping: 1,
      item_name: self.purchase_name,
      item_number: @product.id
    }

    "https://www.paypal.com/cgi-bin/websr?" + values.to_query
  end

  def purchase_name
    "Podmedics Subscription for #{@product.duration} months"
  end

end
