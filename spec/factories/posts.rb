# == Schema Information
#
# Table name: posts
#
#  id                       :integer          not null, primary key
#  title                    :string(255)
#  content                  :text
#  author_id                :integer
#  created_at               :datetime
#  updated_at               :datetime
#  title_image_file_name    :string(255)
#  title_image_content_type :string(255)
#  title_image_file_size    :integer
#  title_image_updated_at   :datetime
#  slug                     :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    title "MyString"
    content "MyText"
    author nil
  end
end
