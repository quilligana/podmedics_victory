require 'spec_helper'

describe Video do
  it { should respond_to :preview }
  it { should respond_to :comment_count }
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

  describe "comment_count function" do
    before do
      @user = build(:user)
      @video = create(:video)
      @visible_comment = @video.comments.create(user: @user, 
                                                content: "This is a reply")
      @hidden_comment = @video.comments.create( user: @user, 
                                                content: "This is a hidden reply", 
                                                hidden: true)
    end

    describe "with only_visible as true" do
      it "should return a count of only visible comments" do
        expect(@video.comment_count(true)).to eq 1
      end
    end

    describe "with only_visible as false" do
      it "should return a count of all comments" do
        expect(@video.comment_count(false)).to eq 2
      end
    end

    describe "should be recursive" do
      it "should include nested comments" do
        expect{@visible_comment.comments.create(user: @user, 
                                                content: "This is a nested reply")}.to change{@video.comment_count(true)}.by(1)
      end
    end
  end
  
end
