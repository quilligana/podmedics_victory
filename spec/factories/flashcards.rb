# == Schema Information
#
# Table name: flashcards
#
#  id             :integer          not null, primary key
#  specialty_id   :integer
#  video_id       :integer
#  views          :integer          default(0)
#  title          :string(255)
#  epidemiology   :text
#  pathology      :text
#  causes         :text
#  signs          :text
#  symptoms       :text
#  inv_cultures   :text
#  inv_bloods     :text
#  inv_imaging    :text
#  inv_scopic     :text
#  inv_functional :text
#  treat_cons     :text
#  treat_medical  :text
#  treat_surgical :text
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#

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
