require 'spec_helper'

describe "video comments" do

  before do
    @user = create(:user)
    @video = create(:video)
    @specialty = create(:specialty)
    sign_in(@user)
    visit video_path(@video)
  end

  subject { page }

  describe "video page" do
    it "should have the notes form" do
      expect(page).to have_button("Save Notes")
    end
  end

  describe "saving notes", js: true do
    describe "with bad data" do
      before do
        click_button "Save Notes"
      end

      it "should not save the notes" do
        expect(page).to have_content("Notes failed to save.")
        expect(Note.all.count).to eq 0
      end
    end
  end
end
