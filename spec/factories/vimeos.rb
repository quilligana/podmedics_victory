# == Schema Information
#
# Table name: vimeos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  video_id   :integer
#  progress   :decimal(, )      default(0.0)
#  completed  :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vimeo do
    user_id 1
    video_id 1
    progress "0"
    completed false
  end
end
