class Specialty < ActiveRecord::Base
  belongs_to :category

  delegate :name, to: :category, prefix: true
end
