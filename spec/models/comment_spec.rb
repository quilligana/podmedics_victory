require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  before do
    @user = create(:user)
    @video = create(:video)
    @comment = Comment.create(commentable: @video, 
                              user: @user, 
                              content: "comment text",
                              video: @video)
  end

  subject { @comment }

  it { should respond_to :user }
  it { should respond_to :content }
  it { should respond_to :commentable }
  it { should respond_to :comments }
  it { should respond_to :hidden }
  it { should respond_to :hide }
  it { should respond_to :show }
  it { should respond_to :video }

  it { should be_valid }
  
  describe "without required variable" do
    describe "content" do
      before do
        @comment.content = nil
      end
    
      it { should_not be_valid }
    end
    
    describe "user" do
      before do
        @comment.user = nil
      end
      
      it { should_not be_valid }
    end

    describe "commentable" do
      before do
        @comment.commentable = nil
      end
      
      it { should_not be_valid }
    end
  end

  describe "when destroyed" do
    before do
      @reply = @comment.comments.new( commentable: @comment,
                                      user: @user,
                                      content: "reply text")
      @comment.destroy
    end

    it "should destroy replies" do
      assert !Comment.exists?(@reply)
    end
  end

  describe "when commentable is destroyed" do
    before do
      @comment.commentable.destroy
    end

    it "should be destroyed" do
      assert !Comment.exists?(@comment)
    end
  end

  describe "hide/show functions" do
    describe "hide" do
      before do
        @comment.hidden = false
        @comment.hide
      end

      it "should set comments hidden variable to true" do
        expect(@comment.hidden).to eq true
      end
    end

    describe "show" do
      before do
        @comment.hidden = true
        @comment.show
      end

      it "should set comments hidden variable to true" do
        expect(@comment.hidden).to eq false
      end
    end

    describe "when hidden" do
      before do
        @comment.hide
      end

      it "should not count towards commentable's comment count" do
        expect(@comment.video.comments_count(true)).to eq 0
      end
    end
  end
end
