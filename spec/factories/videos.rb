FactoryGirl.define do
  factory :video do
    title "Heart Failure"
    description "A video all about heart failure"
    association :specialty
    vimeo_identifier 123456
    duration 10
    file_name 'static_file'
    association :author

    factory :preview_video do
      preview true
    end
  end
end
