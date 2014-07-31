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

class Faq < ActiveRecord::Base

  validates :title, :content, presence: true

  def self.public
    where(member_only: false)
  end

  def self.for_members
    where(member_only: true)
  end

end
