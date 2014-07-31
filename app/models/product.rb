# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  permalink   :string(255)
#  description :text
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  duration    :integer
#

class Product < ActiveRecord::Base

  has_many :sales

  validates :name, :price, presence: true

  def free?
    price == 0 ? true : false
  end

  def paid?
    price > 0 ? true : false
  end

  def price_in_pounds
    price / 100
  end


end
