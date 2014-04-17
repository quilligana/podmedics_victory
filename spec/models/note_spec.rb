require 'spec_helper'

describe Note do

  it { should belong_to :user }
  it { should belong_to :specialty }
  it { should belong_to :noteable }
  it { should validate_presence_of :content }

  describe Note, '#get_title' do
    it "sets the title to the video title if not set" do
      video = create(:video)
      note = build(:note, noteable: video, title: '')
      expect(note.get_title).to eq video.title
    end
    
  end

end
