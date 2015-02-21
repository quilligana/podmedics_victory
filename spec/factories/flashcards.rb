# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flashcard do
    specialty_id 1
    video_id 1
    views 1
    epidemiology "MyText"
    pathology "MyText"
    causes "MyText"
    signs "MyText"
    symptoms "MyText"
    inv_cultures "MyText"
    inv_bloods "MyText"
    inv_imaging "MyText"
    inv_scopic "MyText"
    inv_functional "MyText"
    treat_cons "MyText"
    treat_medical "MyText"
    treat_surgical "MyText"
  end
end
