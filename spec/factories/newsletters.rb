# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsletter do
    subject "MyString"
    body_content "MyText"
    body_text "MyText"
    sent_at ""
  end
end
