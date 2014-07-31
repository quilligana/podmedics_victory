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

require 'spec_helper'

describe Author do

  it { should have_many :videos }

  it { should validate_presence_of :name }
  it { should validate_presence_of :tagline }
  it { should respond_to :twitter }
  it { should respond_to :facebook }

  it "has a valid factory" do
    expect(build(:author)).to be_valid
  end

end
