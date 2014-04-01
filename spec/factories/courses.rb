# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    title "MyString"
    date "2014-04-01 18:25:48"
    price "9.99"
    description "MyText"
    event_link "MyString"
  end
end
