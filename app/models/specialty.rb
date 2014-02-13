class Specialty < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :name

  delegate :name, to: :category, prefix: true
end
