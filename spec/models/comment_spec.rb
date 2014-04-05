require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  before do
    @user = build(:user)
    @comment = Comment.create(commentable: create(:video), 
                              user: @user, 
                              content: "comment text")
  end

  subject { @comment }

  it { should respond_to :user }
  it { should respond_to :content }
  it { should respond_to :commentable }
  it { should respond_to :comments }
  it { should respond_to :hidden }
  it { should respond_to :hide }
  it { should respond_to :show }
  it { should respond_to :comment_count }

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
        expect(@comment.commentable.comment_count(true)).to eq 0
      end
    end
  end

  describe "comment_count function" do
    before do
      @visible_comment = @comment.comments.create(user: User.first, 
                                                  content: "This is a reply")
      @hidden_comment = @comment.comments.create( user: User.first, 
                                                  content: "This is a hidden reply", 
                                                  hidden: true)
    end

    describe "with only_visible as true" do
      it "should return a count of only visible comments" do
        expect(@comment.comment_count(true)).to eq 1
      end
    end

    describe "with only_visible as false" do
      it "should return a count of all comments" do
        expect(@comment.comment_count(false)).to eq 2
      end
    end

    describe "should be recursive" do
      it "should include nested comments" do
        expect{@visible_comment.comments.create(user: User.first, 
                                                content: "This is a nested reply")}.to change{@comment.comment_count(true)}.by(1)
      end
    end
  end
end
