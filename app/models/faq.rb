class Faq < ActiveRecord::Base

  validates :title, :content, presence: true
end
