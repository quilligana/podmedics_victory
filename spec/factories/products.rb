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

FactoryGirl.define do
  factory :product do
    name 'Year Membership'
    description 'This is the one you should go for'
    price 3000

    trait :free do
      permalink 'free'
      price 0
    end

    trait :paid6 do
      permalink 'paid6'
      price 1500
    end

    trait :paid12 do
      permalink 'paid12'
      price 3000
    end

    factory :free_product, traits: [:free]
    factory :paid6_product, traits: [:paid6]
    factory :paid12_product, traits: [:paid12]
  end
end
