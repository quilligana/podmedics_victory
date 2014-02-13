class Specialty < ActiveRecord::Base
  belongs_to :category
  has_many :videos

  validates_presence_of :name

  delegate :name, to: :category, prefix: true
end
