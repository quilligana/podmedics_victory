require 'spec_helper'

describe "video comments" do

  before do
    @user = create(:user)
    @video = create(:video)
    sign_in(@user)
    visit video_path(@video)
  end

  subject { page }

  describe "before posting a comment" do
    it "should not have any comments" do
      expect(page).to have_content("Nothing posted yet. Be the first to comment.")
      expect(page).to have_content("Comments (0)")
    end
  end

  describe "posting a comment" do
    describe "with a valid message", :js => true do
      before do
        fill_in "comment_content", with: "This is a comment."
        click_button "Create Comment"
      end

      Capybara.using_wait_time 10 do
        it "should have a new comment" do
          expect(page).to     have_content(@user.name)
          expect(page).to     have_content("Comments (1)")
          expect(page).to     have_selector("div.comment")
          expect(page).to     have_content("This is a comment.")
          expect(page).to     have_css( "div.comment div.inner_page_padding div.comment_info p", 
                                        text: "This is a comment.")
          expect(page).to_not have_content("Nothing posted yet. Be the first to comment.")
        end
      end
    end

    describe "with an invalid message", :js => true do
      before do
        fill_in "comment_content", with: ""
        click_button "Create Comment"
      end

      Capybara.using_wait_time 10 do
        it "should not have any comments" do
          expect(page).to     have_content("ERROR")
          expect(page).to     have_content("Comments (0)")
          expect(page).to     have_content("There has been a problem")
          expect(page).to     have_content("Nothing posted yet. Be the first to comment.")
          expect(page).to_not have_content(@user.name)
          expect(page).to_not have_content("This is a comment.")
          expect(page).to_not have_css( "div.comment div.inner_page_padding div.comment_info p", 
                                        text: "This is a comment.")
        end
      end
    end

    describe "that is a reply", :js => true do
      before do
        fill_in "comment_content", with: "This is a comment."
        click_button "Create Comment"

        sleep 1.seconds

        fill_in "comment_commentable_id", with: Comment.first.id
        fill_in "comment_commentable_type", with: "Comment"
        fill_in "comment_content", with: "This is a reply."
        click_button "Create Comment"
      end

      Capybara.using_wait_time 10 do
        it "should have a reply comment" do
          expect(page).to     have_content(@user.name)
          expect(page).to     have_content("Comments (2)")
          expect(page).to     have_content("This is a reply.")
          expect(page).to     have_selector("div.comment_reply")
          expect(page).to     have_css( "div.comment_reply div.comment div.inner_page_padding div.comment_info p", 
                                        text: "This is a reply.")
        end
      end
    end

    describe "commenting after replying", :js => true do
      before do
        fill_in "comment_content", with: "This is a comment."
        click_button "Create Comment"

        sleep 1.seconds

        fill_in "comment_commentable_id", with: Comment.first.id
        fill_in "comment_commentable_type", with: "Comment"
        fill_in "comment_content", with: "This is a reply."
        click_button "Create Comment"

        sleep 1.seconds

        fill_in "comment_content", with: "This is a comment after a reply."
        click_button "Create Comment"
      end

      Capybara.using_wait_time 10 do
        it "should have a new non-reply comment" do
          expect(page).to      have_content(@user.name)
          expect(page).to      have_selector("div.comment")
          expect(page).to      have_content("Comments (3)")
          expect(page).to      have_content("This is a comment after a reply.")
          expect(page).to      have_css( "div.comment div.inner_page_padding div.comment_info p", 
                                         text: "This is a comment after a reply.")
          expect(page).to_not have_content("Nothing posted yet. Be the first to comment.")
        end
      end
    end
  end
end