require 'spec_helper'

describe Comment do

  it { should belong_to :commentable }
  it { should belong_to :root }
  it { should belong_to :user}
  it { should have_many :comments }
  it { should have_many :votes }
  it { should validate_presence_of :user }
  it { should validate_presence_of :content }
  it { should validate_presence_of :commentable }

  before do
    @user = create(:user)
    @video = create(:video)
    @comment = Comment.create(commentable: @video, 
                              user: @user, 
                              content: "comment text",
                              root: @video)
  end

  subject { @comment }

  it { should be_valid }

  describe Comment, "on destroy" do
    before do
      @reply = @comment.comments.new( commentable: @comment,
                                      user: @user,
                                      content: "reply text")
      @comment.destroy
    end

    it "should destroy replies" do
      expect(Comment.exists?(@reply)).to be_false
    end
  end

  describe "when commentable is destroyed" do
    before do
      @comment.commentable.destroy
    end

    it "should be destroyed" do
      expect(Comment.exists?(@reply)).to be_false
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
        expect(@comment.root.comments_count).to eq 0
      end
    end
  end

  describe "get_comments" do
    before do
      comment_reply = @comment.comments.create( user: @user, 
                                                content: "hidden content",
                                                root: @video)
      hidden_comment_reply = @comment.comments.create(user: @user, 
                                                      content: "hidden content", 
                                                      hidden: true,
                                                      root: @video)
    end

    describe "without include_hidden as false" do
      it "should return a list of comments" do
        expect(@comment.get_comments(false).count).to eq 1
      end
    end

    describe "with include_hidden as true" do
      it "should return a list of comments" do
        expect(@comment.get_comments(true).count).to eq 2
      end
    end
  end

  describe ".votable?" do
    describe "when the root is a specialty_question" do
      before do
        @specialty_question = SpecialtyQuestion.new(user: @user,
                                                    content: "question?")
        @comment.root = @specialty_question
        @comment.save
      end

      it "should be votable" do
        expect(@comment.votable?).to be_true
      end
    end

    describe "when the root is not a specialty_question" do
      it "should not be votable" do
        expect(@comment.votable?).to_not be_true
      end
    end
  end

  describe ".acceptable?" do
    describe "when the root is a specialty_question" do
      before do
        @specialty_question = SpecialtyQuestion.new(user: @user,
                                                    content: "question?")
        @comment.root = @specialty_question
        @comment.save
      end

      it "should be acceptable" do
        expect(@comment.acceptable?).to be_true
      end
    end

    describe "when the root is not a specialty_question" do
      it "should not be acceptable" do
        expect(@comment.acceptable?).to_not be_true
      end
    end
  end

  describe ".already_voted?(user)" do
    before do
      @newUser = build(:user)
      @comment.root = SpecialtyQuestion.new(user: @user,
                                            content: "question?")
      @comment.save
    end

    describe "when the user has voted for a comment already" do
      before do
        @comment.vote(@newUser)
      end

      it "should return true" do
        expect(@comment.already_voted?(@newUser)).to be_true
      end
    end

    describe "when the user has not voted for a comment yet" do
      it "should return false" do
        expect(@comment.already_voted?(@newUser)).to_not be_true
      end
    end
  end

  describe ".accept" do
    describe "when the comment is not acceptable" do
      it "should not change anything" do
        expect(@comment.accept).to_not be_true
      end
    end

    describe "when the comment is acceptable" do
      before do
        @comment.root = SpecialtyQuestion.new(user: @user,
                                              content: "question?")
      end

      it "should make the comment acceptable" do
        expect(@comment.accept).to be_true
      end
    end
  end

  describe ".vote" do
    before do
      @comment.votes.delete_all
    end

    describe "when the comment is not votable" do
      before do
        @comment.vote(@user)
      end

      it "should not change anything" do
        expect(@comment.score).to eq 0
      end
    end

    describe "when the comment is votable" do
      before do
        @comment.root = SpecialtyQuestion.new(user: @user,
                                              content: "question?")
        @comment.vote(@user)
      end

      it "should make the comment acceptable" do
        expect(@comment.score).to eq 1
      end
    end
  end

  describe "when created" do
    before do
      @user = create(:user)
      @question = SpecialtyQuestion.new(user: @user,
                                        content: "question?")
      @comment = Comment.create(commentable: @question, 
                                user: @user, 
                                content: "comment text",
                                root: @question)
    end

    it "should have a vote from its creator" do
      expect(@comment.score).to eq 1
      expect(@comment.already_voted?(@user)).to be_true
    end
  end
end
