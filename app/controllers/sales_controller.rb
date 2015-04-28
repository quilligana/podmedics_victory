class SalesController < ApplicationController
  
  def show
    @sale = Sale.find(params[:id])
    respond_to do |format|
      format.pdf { send_data @sale.receipt.render, 
                   filename: "#{@sale.created_at.strftime("%Y-%m-%d")}-podmedics-receipt.pdf",
                   type: "application/pdf",
                   disposition: "inline"
                 }
    end
  end

end
