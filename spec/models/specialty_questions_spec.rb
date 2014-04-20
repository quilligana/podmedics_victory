require 'spec_helper'

describe SpecialtyQuestion do

  it { should belong_to :user }
  it { should belong_to :specialty }

  before do
    @category = create(:category, name: 'Medicine') 
    @specialty = create(:specialty, category: @category)
    @user = build(:user)
    @specialty_question = @specialty.user_questions.create(user: @user, content: "This is a question.")
  end

  subject { @specialty_question }

  it { should respond_to :user }
  it { should respond_to :content }
  it { should respond_to :specialty }
  it { should respond_to :comments_count }
  it { should respond_to :get_answers }
  it { should respond_to :comments_count }
  it { should respond_to :accept_answer }
  it { should respond_to :accepted_answer }
  it { should respond_to :already_accepted_answer? }

  it { should have_many(:answers).class_name("Comment").dependent(:destroy) }
  it { should have_many(:nested_answers).class_name("Comment") }

  it { should validate_presence_of :content }
  it { should validate_presence_of :specialty }
  it { should validate_presence_of :user }

  it { should be_valid }

  describe ".get_answers" do
    before do
      comment = @specialty_question.answers.create( user: @user, 
                                                    content: "content",
                                                    root: @specialty_question)
      hidden_comment = @specialty_question.answers.create(user: @user, 
                                                          content: "hidden content", 
                                                          hidden: true,
                                                          root: @specialty_question)
    end

    describe "without include_hidden as false" do
      it "should return a list of comments" do
        expect(@specialty_question.get_answers(false).count).to eq 1
      end
    end

    describe "with include_hidden as true" do
      it "should return a list of comments" do
        expect(@specialty_question.get_answers(true).count).to eq 2
      end
    end
  end

  describe ".comments_count" do
    before do
      comment = @specialty_question.answers.create( user: @user, 
                                                    content: "content",
                                                    root: @specialty_question)
      hidden_comment = @specialty_question.answers.create(user: @user, 
                                                          content: "hidden content", 
                                                          hidden: true,
                                                          root: @specialty_question)
    end

    describe "without include_hidden as false" do
      it "should return a list of comments" do
        expect(@specialty_question.comments_count(false)).to eq 1
      end
    end

    describe "with include_hidden as true" do
      it "should return a list of comments" do
        expect(@specialty_question.comments_count(true)).to eq 2
      end
    end
  end

  describe ".accept_answer" do
    describe "when the question was created by the user" do
      before do
        @specialty_question = @specialty.user_questions.create(user: @user, content: "This is a question.")
        @answer = @specialty_question.answers.create(user: @user, content: "content", root: @specialty_question)
      end

      it "should set the answer as accepted" do
        expect(@answer.accepted).to_not be_true
        @specialty_question.accept_answer(@answer, @user)
        expect(@answer.accepted).to be_true
      end
    end

    describe "when the question was not created by the user" do
      before do
        @specialty_question = @specialty.user_questions.create(user: @user, content: "This is a question.")
        @answer = @specialty_question.answers.create(user: @user, content: "content", root: @specialty_question)
        @new_user = build(:user)
      end

      it "should not set the answer as accepted" do
        expect(@answer.accepted).to_not be_true
        @specialty_question.accept_answer(@answer, @new_user)
        expect(@answer.accepted).to_not be_true
      end
    end

    describe "when the question already has an accepted answer" do
      before do
        @specialty_question = @specialty.user_questions.create(user: @user, content: "This is a question.")
        @answer = @specialty_question.answers.create(user: @user, content: "content", root: @specialty_question)
        @answer_2 = @specialty_question.answers.create(user: @user, content: "content", root: @specialty_question)
        @specialty_question.accept_answer(@answer, @user)
      end

      it "should not set the answer as accepted" do
        expect(@answer_2.accepted).to_not be_true
        @specialty_question.accept_answer(@answer_2, build(:user))
        expect(@answer_2.accepted).to_not be_true
      end
    end
  end

  describe ".accepted_answer" do
    before do
      @specialty_question = @specialty.user_questions.create(user: @user, content: "This is a question.")
      @answer = @specialty_question.answers.create(user: @user, content: "content", root: @specialty_question)
      @specialty_question.accept_answer(@answer, @user)
    end

    it "should return the accepted answer" do
      expect(@specialty_question.accepted_answer).to eq @answer
    end
  end
end
