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

require 'spec_helper'

describe Post do

  it { should belong_to :author }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { should validate_presence_of :author_id }

end
