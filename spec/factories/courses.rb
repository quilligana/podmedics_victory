# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  date        :datetime
#  price       :decimal(, )
#  description :text
#  event_link  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :course do
    title "HouseOfficer Course"
    date "2014-04-01 18:25:48"
    price 30
    description "Some really long description with html formatting"
    event_link "http://podmedics.com"
  end
end
