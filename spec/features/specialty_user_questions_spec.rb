require 'spec_helper'

describe "specialty user questions and answers" do

  before do
    @question_text = "Question text"
    @comment_text = "This is a comment."
    @reply_text = "This is a reply."

    @user_one = create(:user)
    @user_two = create(:user)
    @category = create(:category, name: 'Medicine')
    @specialty = create(:specialty, category: @category)
    sign_in(@user_one)
    visit specialty_path(@specialty)
  end

  subject { page }

  shared_examples_for "a question_page" do
    it "should be a question page" do
      expect(page).to have_content @question_text
      expect(page).to have_content @user_one.name
      expect(page).to have_content "Posted less than a minute ago by"
      expect(page).to have_link "Delete Question"
    end
  end

  describe "before any questions are posted" do
    before do
      visit specialty_questions_path(@specialty)
    end

    it "should not have any questions" do
      expect(page).to_not have_content "asked a question"
      expect(page).to_not have_selector ".questions_answers_question"
    end

    it "should say there are no questions" do
      expect(page).to     have_selector ".no_questions_reply_wrapper"
    end
  end

  describe "submitting a question", js: true do
    describe "from the specialty page" do
      before do
        submit_question
      end

      it_should_behave_like "a question_page"
    end

    describe "from the specialty question index page" do
      before do
        visit specialty_questions_path(@specialty)
        submit_question
      end

      it_should_behave_like "a question_page"
    end

    describe "from the specialty question show page" do
      before do
        visit specialty_questions_path(@specialty)
        submit_question
        submit_question
      end

      it_should_behave_like "a question_page"
    end

    describe "with no content" do
      before do
        click_link "Ask a Question"
        click_button "Create Specialty question"
      end

      it "should not post a question" do
        expect(page).to_not have_content @question_text
        expect(page).to_not have_content @user_one.name
        expect(page).to_not have_content "Posted less than a minute ago by"
        expect(page).to_not have_link "Delete Question"
      end
    end
  end

  describe "clicking delete" do
    before do
      submit_question
      click_link "Delete Question"
    end

    it "should delete a question" do
      expect(SpecialtyQuestion.all.count).to eq 0
    end
  end

  describe "answering a question", js: true do
    before do
      submit_question
      sign_in(@user_two)
      visit specialty_question_path(Specialty.first, SpecialtyQuestion.first)
      fill_in "comment_content", with: @comment_text
      click_button "Post"
    end

    Capybara.using_wait_time 10 do
      it "should have a new answer" do
        expect(page).to     have_content(@user_two.name)
        expect(page).to     have_content("1 Answers")
        expect(page).to     have_selector("div.comment")
        expect(page).to     have_content(@comment_text)
        expect(page).to     have_css( "div.comment div.inner_page_padding div.comment_info p", 
                                      text: @comment_text)
        expect(page).to_not have_content("Nothing posted yet. Be the first to comment.")
      end
    end

    describe "and then replying to that question" do
      before do
        sleep 1.seconds
        fill_in "comment_commentable_id", with: Comment.first.id
        fill_in "comment_commentable_type", with: "Comment"
        fill_in "comment_content", with: @reply_text
        click_button "Post"
      end


      Capybara.using_wait_time 10 do
        it "should have a reply comment" do
          expect(page).to     have_content(@user_one.name)
          expect(page).to     have_content("2 Answers")
          expect(page).to     have_content("This is a reply.")
          expect(page).to     have_selector("div.comment_reply")
          expect(page).to     have_css( "div.comment_reply div.comment div.inner_page_padding div.comment_info p", 
                                        text: @reply_text)
        end
      end
    end

    describe "voting for a question" do
      before do
        sign_in(@user_one)
        visit specialty_question_path(Specialty.first, SpecialtyQuestion.first)
      end

      it "should increase the score of the comment" do
        expect(page).to     have_content "SCORE: 1"
        click_link "^"
        expect(page).to     have_content "SCORE: 2"
        expect(page).to_not have_content "^"
      end
    end

    describe "accepting an answer" do
      before do
        sign_in(@user_one)
        visit specialty_question_path(Specialty.first, SpecialtyQuestion.first)
      end

      it "should increase the comment's score by 5" do
        expect(page).to_not have_content "SCORE: 6" 
        expect(page).to have_content "SCORE: 1" 
        click_link "Accept Answer"
        expect(page).to_not have_content "SCORE: 1" 
        expect(page).to have_content "SCORE: 6"
      end 

      it "should set a comment as the accepted answer" do
        expect(page).to_not have_content "THIS IS THE ACCEPTED ANSWER"
        click_link "Accept Answer"
        expect(page).to have_content "THIS IS THE ACCEPTED ANSWER"
      end

      it "should remove accept answer link from page" do
        expect(page).to have_content "ACCEPT ANSWER"
        click_link "Accept Answer"
        expect(page).to_not have_content "ACCEPT ANSWER"
      end
    end
  end

  describe "Load More Questions button on index page", js: true do
    before do
      @question_one_text = "Question one"
      @question_two_text = "Question two"
      @question_three_text = "Question three"
      @question_text = @question_one_text
      submit_question
      @question_text = @question_two_text
      submit_question
      @question_text = @question_three_text
      submit_question
    end

    it "should display latest page before being clicked" do
      visit specialty_questions_path(@specialty)
      expect(page).to     have_content @question_three_text
      expect(page).to_not have_content @question_one_text
      expect(page).to_not have_content @question_two_text
    end

    it "should display latest two pages after being clicked" do
      visit specialty_questions_path(@specialty)
      click_link "Load More Questions"
      expect(page).to     have_content @question_three_text
      expect(page).to     have_content @question_two_text
      expect(page).to_not have_content @question_one_text
    end

    it "should display latest three pages after being clicked twice" do
      visit specialty_questions_path(@specialty)
      click_link "Load More Questions"
      sleep 1.second
      click_link "Load More Questions"
      expect(page).to have_content @question_three_text
      expect(page).to have_content @question_two_text
      expect(page).to have_content @question_one_text
    end

    it "should inform the user when there are no questions to load" do
      visit specialty_questions_path(@specialty)
      click_link "Load More Questions"
      sleep 1.second
      click_link "Load More Questions"
      sleep 1.second
      click_link "Load More Questions"
      expect(page).to_not have_link "Load More Questions"
      expect(page).to_not have_link "Reached End Of Questions"
    end
  end
end
