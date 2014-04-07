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
    it { should have_content("Nothing posted yet. Be the first to comment.") }
    it { should have_content("Comments (0)") }
    it { should_not have_content(@user.name) }
  end

  describe "posting a comment" do
    describe "with a valid message", :js => true do
      before do
        fill_in "comment_content", with: "This is a comment."
        click_button "Create Comment"
      end

      Capybara.using_wait_time 10 do
        it { should have_css( "div.comment div.inner_page_padding div.comment_info p", 
                              text: "This is a comment.") }
        it { should have_selector("div.comment") }
        it { should have_content("This is a comment.") }
        it { should_not have_content("Nothing posted yet. Be the first to comment.") }
        it { should have_content(@user.name) }
        it { should have_content("Comments (1)") }
      end
    end

    describe "with an invalid message", :js => true do
      before do
        fill_in "comment_content", with: ""
        click_button "Create Comment"
      end

      Capybara.using_wait_time 10 do
        it { should_not have_css( "div.comment div.inner_page_padding div.comment_info p", 
                                  text: "This is a comment.") }
        it { should_not have_content("This is a comment.") }
        it { should have_content("Nothing posted yet. Be the first to comment.") }
        it { should_not have_content(@user.name) }
        it { should have_content("ERROR") }
        it { should have_content("There has been a problem") }
        it { should have_content("Comments (0)") }
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
        it { should have_css( "div.comment_reply div.comment div.inner_page_padding div.comment_info p", 
                              text: "This is a reply.") }
        it { should have_selector("div.comment_reply") }
        it { should have_content("This is a reply.") }
        it { should have_content(@user.name) }
        it { should have_content("Comments (2)") }
      end
    end
  end
end