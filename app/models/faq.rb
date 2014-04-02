class Faq < ActiveRecord::Base

  validates :title, :content, presence: true

  def self.for_members
    where(member_only: true)
  end

end
