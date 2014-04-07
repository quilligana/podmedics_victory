require 'spec_helper'

describe Video do
  it { should respond_to :preview }
  it { should respond_to :position }
  it { should belong_to :specialty }
  it { should have_many :questions }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :specialty_id }
  it { should validate_presence_of :duration }
  it { should validate_presence_of :vimeo_identifier }
  it { should validate_presence_of :file_name }

  describe Video, '.specialty_name' do
    it "delegates to specialty" do
      specialty = create(:specialty, name: 'Cardiology')
      video = create(:video, specialty: specialty)
      expect(video.specialty_name).to eq 'Cardiology'
    end
  end

  it "has a counter cache" do
    video = create(:video)
    expect {
      create(:question, video: video)
    }.to change { Video.last.questions_count}.by(1)
  end  

end
