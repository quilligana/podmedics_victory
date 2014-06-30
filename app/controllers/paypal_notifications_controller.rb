class PaypalNotificationsController < ApplicationController
  protect_from_forgery except: [:create]

  # need to make this work properly by inspect the params in a real callback
  def create
    # get the data from the callback
  end

end
