# == Schema Information
#
# Table name: newsletters
#
#  id           :integer          not null, primary key
#  subject      :string(255)
#  body_content :text
#  body_text    :text
#  sent_at      :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsletter do
    subject "MyString"
    body_content "MyText"
    body_text "MyText"
    sent_at ""
  end
end
