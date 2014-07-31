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

require 'spec_helper'

describe Course do

  it { should validate_presence_of :title }
  it { should validate_presence_of :date }
  it { should validate_presence_of :price }
  it { should validate_presence_of :description }
  it { should validate_presence_of :event_link }

end
