require 'spec_helper'

describe Video do
  it { should respond_to :preview }
  it { should respond_to :position }
  it { should respond_to :get_comments }
  it { should respond_to :comments_count }
  it { should respond_to :video_download_count }
  it { should respond_to :audio_download_count }
  it { should respond_to :slide_download_count }
  it { should belong_to :specialty }
  it { should belong_to :author }
  it { should have_many :questions }
  it { should have_many :comments }
  it { should have_many :nested_comments }
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

  describe Video, '.author_name' do
    before do
      @author = create(:author)
      @video = create(:video, author: @author)
    end

    it "delegates name of author to author_name" do
      expect(@video.author_name).to eq @author.name
    end

    it "delegates tagline of author to author_tagline" do
      expect(@video.author_tagline).to eq @author.tagline
    end

    it "delegates twitter of author to author_twitter" do
      expect(@video.author_twitter).to eq @author.twitter
    end

    it "delegates twitter of author to author_twitter" do
      expect(@video.author_facebook).to eq @author.facebook
    end

  end

  it "has a counter cache" do
    video = create(:video)
    expect {
      create(:question, video: video)
    }.to change { Video.last.questions_count}.by(1)
  end  

  describe Video, ".get_comments" do
    before do
      @video = create(:video)
      user = create(:user)
      comment = @video.comments.create( user: user, 
                                        content: "content",
                                        root: @video)
      hidden_comment = @video.comments.create( user: user, 
                                              content: "hidden content", 
                                              hidden: true,
                                               root: @video)
      @video.save
    end

    describe "without include_hidden as false" do
      it "should return a list of comments" do
        expect(@video.get_comments(false).count).to eq 1
      end
    end

    describe "with include_hidden as true" do
      it "should return a list of comments" do
        expect(@video.get_comments(true).count).to eq 2
      end
    end
  end

  describe Video, ".comments_count" do
    before do
      @video = create(:video)
      user = create(:user)
      comment = @video.comments.create( user: user, 
                                        content: "content",
                                        root: @video)
      hidden_comment = @video.comments.create( user: user, 
                                               content: "hidden content", 
                                               hidden: true,
                                               root: @video)
      @video.save
    end

    describe "without include_hidden as false" do
      it "should return a list of comments" do
        expect(@video.comments_count(false)).to eq 1
      end
    end

    describe "with include_hidden as true" do
      it "should return a list of comments" do
        expect(@video.comments_count(true)).to eq 2
      end
    end
  end
end
