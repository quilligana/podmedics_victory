# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vimeo do
    user_id 1
    video_id 1
    progress "9.99"
    completed false
  end
end
