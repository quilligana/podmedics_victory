
FactoryGirl.define do
  factory :faq do
    title "How to login"
    content "Fill in your username and password and click the login button"

    factory :member_faq do
      member_only true
    end
  end
end
