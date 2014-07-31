# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Category do

  it { should validate_presence_of :name}
  it { should have_many :specialties}
  it { should have_many :videos }

  describe '#video_count' do
    it "shows the correct video count" do
      category = create(:category)
      specialty = create(:specialty, category: category)
      video = create(:video, specialty: specialty)
      expect(category.video_count).to eq 1
    end
  end

end
