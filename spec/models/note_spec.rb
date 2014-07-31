# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  content       :text
#  user_id       :integer
#  specialty_id  :integer
#  created_at    :datetime
#  updated_at    :datetime
#  noteable_id   :integer
#  noteable_type :string(255)
#  category_id   :integer
#

require 'spec_helper'

describe Note do

  it { should belong_to :user }
  it { should belong_to :specialty }
  it { should belong_to :noteable }
  it { should validate_presence_of :content }

  describe Note, '#get_title' do
    it "sets the title to the noteable title if not set" do
      note = build(:note, title: '')
      expect(note.get_title).to eq note.noteable.title
    end
    
  end

end
