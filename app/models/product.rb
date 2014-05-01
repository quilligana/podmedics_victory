class Product < ActiveRecord::Base

  has_many :sales

  validates :name, :price, presence: true
  validates_numericality_of :price,
    greater_than: 49,
    message: "must be at least 50 pence"

end
