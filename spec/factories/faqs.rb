# == Schema Information
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  member_only :boolean          default(FALSE)
#


FactoryGirl.define do
  factory :faq do
    title "How to login"
    content "Fill in your username and password and click the login button"

    factory :member_faq do
      member_only true
    end
  end
end
