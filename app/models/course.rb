class Course < ActiveRecord::Base
  validates_presence_of :title, :date, :price, :description, :event_link
end
