FactoryGirl.define do
  factory :note do
    title 'Note Title'
    content 'Note Content'
    association :noteable
    association :user
    association :specialty
  end
end
