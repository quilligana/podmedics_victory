require 'spec_helper'

describe "specialty notes", js: true do

  before do
    @content = "This is the content"
    @title = "This is the title"
    @saved_message = "NOTES SAVED"
    @failed_message = "NOTES FAILED TO SAVE."
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

  describe "saving notes" do
    describe "with no content" do
      before do
        fill_in "note_title", with: @title
        click_button "Save Notes"
      end

      it "should not save the notes" do
        expect(page).to have_content(@failed_message)
        expect(Note.all.count).to eq 0
      end
    end

    describe "with no title" do
      before do
        fill_in "note_content", with: @content
        click_button "Save Notes"
      end

      it "should save the notes" do
        expect(page).to have_content(@saved_message)
        expect(Note.all.count).to eq 1
      end
    end

    describe "with correct content" do
      before do
        fill_in "note_title", with: @title
        fill_in "note_content", with: @content
        click_button "Save Notes"
      end

      it "should save the notes" do
        expect(page).to have_content(@saved_message)
        expect(Note.all.count).to eq 1
        expect(Note.first.content).to eq @content
        expect(Note.first.title).to eq @title
      end
    end
  end

  describe "autosave" do
    before do
      fill_in "note_title", with: @title
      fill_in "note_content", with: @content
      sleep 3.second
    end

    Capybara.using_wait_time 10 do
      it "should save automatically every second" do
        expect(page).to have_content(@saved_message)
        expect(Note.all.count).to eq 1
        expect(Note.first.content).to eq @content
        expect(Note.first.title).to eq @title
      end
    end
  end

  describe "revert button" do
    before do
      fill_in "note_title", with: @title
      fill_in "note_content", with: @content
      click_button "Save Notes"
      visit video_path(@video)
      fill_in "note_title", with: "revert from this"
      fill_in "note_content", with: "revert from this"
      click_button "Revert"
      click_button "Save Notes"
    end

    it "should revert notes to previous manual save" do
      expect(Note.first.content).to eq @content
      expect(Note.first.title).to eq @title
    end
  end

  describe "specialty page" do
    before do
      @specialty.notes.create(noteable: @video, user: @user, content: @content, title: @title)
      visit specialty_path(@specialty)
      click_link "notes_saved_button"
    end

    it "should show that specialty's notes" do
      expect(page).to have_content @title.upcase 
    end

    describe "clicking on read button" do
      before do
        click_link "Read"
      end

      it "should show the whole set of notes" do
        expect(page).to have_content @content
      end
    end
  end
end