require 'spec_helper'

describe SpecialtyQuestion do

  it { should belong_to :user }
  it { should belong_to :specialty }

  before do
    @category = create(:category, name: 'Medicine') 
    @specialty = create(:specialty, category: @category)
    @user = create(:user)
    @specialty_question = create(:specialty_question, user: @user)
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
      comment = create(:comment, user: @user, commentable: @specialty_question)
      hidden_comment = create(:hidden_comment, user: @user, commentable: @specialty_question)
    end

    context "with include_hidden as false" do
      it "does not include hidden comments" do
        expect(@specialty_question.get_answers(false).count).to eq 1
      end
    end

    context "with include_hidden as true" do
      it "does include hidden comments" do
        expect(@specialty_question.get_answers(true).count).to eq 2
      end
    end
  end

  describe ".comments_count" do
    before do
      comment = create(:comment, user: @user, commentable: @specialty_question)
      hidden_comment = create(:hidden_comment, user: @user, commentable: @specialty_question)
    end

    context "without include_hidden as false" do
      it "does not include hidden comments" do
        expect(@specialty_question.comments_count(false)).to eq 1
      end
    end

    context "with include_hidden as true" do
      it "includes hidden comments" do
        expect(@specialty_question.comments_count(true)).to eq 2
      end
    end
  end

  describe ".accept_answer" do
    before do      
        @answer = create(:comment, user: @user, commentable: @specialty_question)
      end

    context "when the question was created by the user" do
      it "sets the answer as accepted" do
        expect{ @specialty_question.accept_answer(@answer, @user) }.to change{ @answer.accepted }
      end
    end

    context "when the question was not created by the user" do
      it "does not set the answer as accepted" do
        expect{ @specialty_question.accept_answer(@answer, create(:user)) }.to_not change{ @answer.accepted }
      end
    end

    context "when the question already has an accepted answer" do
      before do
        @answer_2 = create(:comment, user: @user, commentable: @specialty_question)
        @specialty_question.accept_answer(@answer, @user)
      end

      it "does not set the answer as accepted" do
        expect{ @specialty_question.accept_answer(@answer_2, create(:user)) }.to_not change { @answer_2.accepted }
      end
    end
  end

  describe ".accepted_answer" do
    before do
      @answer = create(:comment, user: @user, commentable: @specialty_question)
      @specialty_question.accept_answer(@answer, @user)
    end

    it "returns the accepted answer" do
      expect(@specialty_question.accepted_answer).to eq @answer
    end
  end
end
