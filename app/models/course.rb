class Course < ActiveRecord::Base

  validates :title, :date, :price, :description, :event_link, presence: true

end
