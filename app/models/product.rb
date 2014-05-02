class Product < ActiveRecord::Base

  has_many :sales

  validates :name, :price, presence: true

  def free?
    price == 0 ? true : false
  end

  def paid?
    price > 0 ? true : false
  end


end
