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

class Course < ActiveRecord::Base

  validates :title, :date, :price, :description, :event_link, presence: true

end
