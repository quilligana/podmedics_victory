require 'spec_helper'

describe Vimeo do
  it { should respond_to :user_id }
  it { should respond_to :video_id }
  it { should respond_to :progress }
  it { should respond_to :completed }
  it { should belong_to :user }
  it { should belong_to :video }

  it 'should respond_to register_ids' do
    video_specialty = create(:specialty)
    video = create(:video, specialty: video_specialty)
    user = create(:user)

    expect do
      Vimeo.register_ids(video.id, user)
    end.to change { Vimeo.count }.by(1)
  end
end
