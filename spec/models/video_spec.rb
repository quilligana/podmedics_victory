# == Schema Information
#
# Table name: videos
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  specialty_id         :integer
#  vimeo_identifier     :string(255)
#  duration             :integer
#  created_at           :datetime
#  updated_at           :datetime
#  preview              :boolean          default(FALSE)
#  slug                 :string(255)
#  speaker_name         :string(255)
#  views                :integer          default(0)
#  file_name            :string(255)
#  questions_count      :integer          default(0), not null
#  position             :integer
#  author_id            :integer
#  slide_download_count :integer
#  audio_download_count :integer
#  video_download_count :integer
#  proofread            :boolean          default(FALSE)
#  has_slides           :boolean          default(TRUE)
#

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
  it { should have_db_index(:specialty_id)}
  it { should have_db_index(:author_id)}

  it { should have_many :questions }
  it { should have_many :comments }
  it { should have_many :nested_comments }
  it { should have_many :notes }
  it { should have_many :taggings }
  it { should have_many(:tags).through(:taggings) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :specialty_id }
  it { should validate_presence_of :duration }
  it { should validate_presence_of :vimeo_identifier }
  it { should validate_presence_of :file_name }


  describe Video, '#specialty_name' do
    it "delegates to specialty" do
      specialty = create(:specialty, name: 'Cardiology')
      video = create(:video, specialty: specialty)
      expect(video.specialty_name).to eq 'Cardiology'
    end
  end

  describe Video, '#author_name' do
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

  describe Video, "#get_comments" do
    before do
      @video = create(:video)
      user = create(:user)
      create(:comment,  user: user, 
                        commentable: @video)
      create(:hidden_comment, user: user, 
                              commentable: @video)
      @video.save
    end

    describe "with include_hidden as false" do
      it "doesn't include hidden comments" do
        expect(@video.get_comments(false).count).to eq 1
      end
    end

    describe "with include_hidden as true" do
      it "includes hidden comments" do
        expect(@video.get_comments(true).count).to eq 2
      end
    end
  end

  describe Video, "#comments_count" do
    before do
      @video = create(:video)
      user = create(:user)
      create(:comment,  user: user, 
                        commentable: @video)
      create(:hidden_comment,  user: user, 
                        commentable: @video)
      @video.save
    end

    describe "with include_hidden as false" do
      it "doesn't include hidden comments" do
        expect(@video.comments_count(false)).to eq 1
      end
    end

    describe "with include_hidden as true" do
      it "includes hidden comments" do
        expect(@video.comments_count(true)).to eq 2
      end
    end
  end

  describe Video, '.recent' do
    before :each do
      @recent_videos = create_list(:video, 5)
      @new_video = create(:video)
    end

    it "shows videos in order of created_at" do
      expect(Video.recent.first).to eq @new_video
    end
  end

  describe Video, '.increment_view_count' do
    it "should increment the video view_count by 1" do
      video = create(:video)
      video.increment_views
      video.reload
      expect(video.views).to eq 1
    end
  end

  describe Video, '.search' do
    it "should search by title" do
      video = create(:video, title: 'Acne')
      expect(Video.search_with('Acne')).to include video
    end
  end

  describe Video, '.tagged_with' do
    before do
      @tagged_video = create(:video, tag_list: 'ischaemia, acute coronary syndrome')
      @non_tagged_video = create(:video)
    end

    it "returns the right video given a tag" do
      expect(Video.tagged_with('ischaemia')).to include @tagged_video
      expect(Video.tagged_with('ischaemia')).to_not include @non_tagged_video
    end
  end

  describe Video, '#tag_list' do
    it "retrieves the tags for a video" do
      video = create(:video, tag_list: 'one, two')
      expect(video.tag_list).to eq 'one, two'
    end
  end

  describe Video, '#tag_list=' do
    it "creates tags given a set of tags and ignores already created tags" do
      expect {
        create(:video, tag_list: 'one, two, one')
      }.to change(Tag, :count).by(2)
      
    end
  end
  

end
