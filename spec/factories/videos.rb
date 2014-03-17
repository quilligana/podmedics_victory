FactoryGirl.define do
  factory :video do
    title "Heart Failure"
    description "A video all about heart failure"
    association :specialty
    vimeo_identifier "1234565"
    duration 10

    factory :preview_video do
      preview true
    end
  end
end
