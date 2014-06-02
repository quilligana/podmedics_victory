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
    @comment = create(:comment, commentable: @video, 
                                user: @user)
  end

  subject { @comment }

  it { should be_valid }

  describe ".destroy" do
    before do
      @reply = create(:comment, commentable: @comment,
                                user: @user)
    end

    it "destroys its replies" do
      expect{ @comment.destroy }.to change{ Comment.exists?(@reply) }.to(false)
    end
  end

  describe "when commentable is destroyed" do
    before do
      @comment.commentable.destroy
    end

    it "destroys the comment" do
      expect(Comment.exists?(@comment)).to be_false
    end
  end

  describe ".hide" do
    it "sets hidden to true" do
      expect{ @comment.hide }.to change{ @comment.hidden }.to(true)
    end
  end

  describe ".show" do
    before do
      @comment.hidden = true
    end

    it "sets hidden to false" do
      expect{ @comment.show }.to change{ @comment.hidden }.to(false)
    end
  end

  describe ".get_comments" do
    before do
      create(:comment,  commentable: @comment,
                        user: @user)
      create(:hidden_comment, commentable: @comment,
                              user: @user)
    end

    context "without include_hidden as false" do
      it "does not include hidden comments" do
        expect(@comment.get_comments(false).count).to eq 1
      end
    end

    context "with include_hidden as true" do
      it "includes hidden comments" do
        expect(@comment.get_comments(true).count).to eq 2
      end
    end
  end

  describe ".votable?" do
    context "when the root is a specialty_question" do
      before do
        @specialty_question = create(:specialty_question, user: @user)
        @comment.root = @specialty_question
        @comment.save
      end

      it "returns true" do
        expect(@comment.votable?).to be_true
      end
    end

    context "when the root is not a specialty_question" do
      it "returns false" do
        expect(@comment.votable?).to_not be_true
      end
    end
  end

  describe ".acceptable?" do
    context "when the root is a specialty_question" do
      before do
        @comment.root = create(:specialty_question)
        @comment.save
      end

      it "returns true" do
        expect(@comment.acceptable?).to be_true
      end
    end

    context "when the root is not a specialty_question" do
      it "returns false" do
        expect(@comment.acceptable?).to_not be_true
      end
    end
  end

  describe ".already_voted?(user)" do
    before do
      @newUser = build(:user)
      @comment.root = create(:specialty_question)
      @comment.save
    end

    context "when the user has voted for a comment already" do
      it "should return true" do
        expect{ @comment.vote(@newUser) }.to change{ @comment.already_voted?(@newUser) }.to(true)
      end
    end

    context "when the user has not voted for a comment yet" do
      it "should return false" do
        expect(@comment.already_voted?(@newUser)).to_not be_true
      end
    end
  end

  describe ".accept" do
    context "when the comment is not acceptable" do
      it "should not change anything" do
        expect(@comment.accept).to_not be_true
      end
    end

    context "when the comment is acceptable" do
      before do
        @comment.root = create(:specialty_question)
      end

      it "makes the answer the accepted answer" do
        expect{ @comment.accept }.to be_true
      end

      it "increases the comment's score by 5" do
        expect{ @comment.accept }.to change{ @comment.score }.by(5)
      end
    end
  end

  describe ".vote" do
    before do
      @comment.votes.delete_all
    end

    context "when the comment is not votable" do
      it "does nothing" do
        expect{ @comment.vote(@user) }.to_not change{ @comment.score }
      end
    end

    context "when the comment is votable" do
      before do
        @comment.root = create(:specialty_question)
      end

      it "increases the score by one" do
        expect{ @comment.vote(@user) }.to change{ @comment.score }.by(1)
      end

      it "voting should change the commenters points" do
        expect(@user.points).to eq(0)

        @comment.vote(create(:user))
        @comment.vote(create(:user))
        @comment.vote(create(:user))
        @user.reload

        expect(@user.points).to eq(3)
      end
    end
  end

  describe "when created" do
    before do
      @user = create(:user)
      @specialty_question = create(:specialty_question)
      @comment = create(:comment, commentable: @specialty_question,
                                  user: @user)
    end

    it "has a single vote" do
      expect(@comment.score).to eq 1
    end

    it "is voted for by its owner" do
      expect(@comment.already_voted?(@user)).to be_true
    end
  end
end
