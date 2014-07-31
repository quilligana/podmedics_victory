# == Schema Information
#
# Table name: authors
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  tagline             :string(255)
#  twitter             :string(255)
#  facebook            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

require 'faker'

FactoryGirl.define do
  factory :author do
    name { Faker::Name.name }
    tagline { Faker::Lorem.sentence }
    twitter { Faker::Internet.url }
    facebook  { Faker::Internet.url }
  end
end
