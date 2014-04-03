require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  before do
    @user = build(:user)
    @comment = Comment.new(	commentable: create(:video), 
                            user: @user, 
                            content: "comment text")
  end

  subject { @comment }

  it { should respond_to :user }
  it { should respond_to :content }
  it { should respond_to :commentable }
  it { should respond_to :comments }

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
end
