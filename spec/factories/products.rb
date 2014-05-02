FactoryGirl.define do
  factory :product do
    name 'Year Membership'
    description 'This is the one you should go for'
    price 3000

    trait :free do
      permalink 'free'
      price 0
    end

    trait :paid do
      permalink 'paid'
      price 3000
    end

    factory :free_product, traits: [:free]
    factory :paid_product, traits: [:paid]
  end
end
