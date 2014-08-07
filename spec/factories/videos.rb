# == Schema Information
#
# Table name: videos
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  specialty_id         :integer
#  vimeo_identifier     :string(255)
#  duration             :integer
#  created_at           :datetime
#  updated_at           :datetime
#  preview              :boolean          default(FALSE)
#  slug                 :string(255)
#  speaker_name         :string(255)
#  views                :integer          default(0)
#  file_name            :string(255)
#  questions_count      :integer          default(0), not null
#  position             :integer
#  author_id            :integer
#  slide_download_count :integer
#  audio_download_count :integer
#  video_download_count :integer
#  proofread            :boolean          default(FALSE)
#  has_slides           :boolean          default(TRUE)
#

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
