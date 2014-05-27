require 'spec_helper'

describe "notes", js: true do

  before do
    @content = "This is the content"
    @title = "This is the title"
    @saved_message = "NOTES SAVED"
    @failed_message = "NOTES FAILED TO SAVE."
    @user = create(:user)
    @video = create(:video)
    @specialty = @video.specialty
    sign_in(@user)
  end

  subject { page }

  shared_examples_for "displaying a note's" do
    it 'title' do
      expect(page).to have_content note.title.upcase
    end

    it 'content' do
      expect(page).to have_content note.content
    end
  end

  shared_examples_for "not displaying a note's" do
    it 'title' do
      expect(page).to_not have_content note.title.upcase
    end

    it 'content' do
      expect(page).to_not have_content note.content
    end
  end

  describe "main page" do
    before do
      @category1 = create(:category, name: "category1")
      @category2 = create(:category, name: "category2")
      @specialty1 = create(:specialty, name: "specialty1")
      @specialty2 = create(:specialty, name: "specialty2")

      @note11 = create(:note, user: @user)
      @note12 = create(:note, user: @user)
      @note22 = create(:note, user: @user)

      @note11.update_attributes(category: @category1, specialty: @specialty1)
      @note12.update_attributes(category: @category1, specialty: @specialty2)
      @note22.update_attributes(category: @category2, specialty: @specialty2)
    end

    describe "with no filters" do
      before do
        visit notes_path
      end
    
      describe 'the notes output section' do
        it_behaves_like "displaying a note's" do
          let(:note) { @note11 }
        end
        it_behaves_like "displaying a note's" do
          let(:note) { @note12 }
        end
        it_behaves_like "displaying a note's" do
          let(:note) { @note22 }
        end
      end
    end

    describe 'with category filter' do
      before do
        visit category_notes_path(@category1)
      end

      it "displays the category's name" do
        expect(page).to have_content @category1.name
      end
  
      describe 'the notes output section' do
        it_behaves_like "displaying a note's" do
          let(:note) { @note11 }
        end
        it_behaves_like "displaying a note's" do
          let(:note) { @note12 }
        end
        it_behaves_like "not displaying a note's" do
          let(:note) { @note22 }
        end
      end
    end
  
    describe 'with specialty filter' do
      before do
        visit specialty_notes_path(@specialty2)
      end

      it "displays the specialty's name" do
        expect(page).to have_content @specialty2.name
      end
    
      describe 'the notes output section' do
        it_behaves_like "not displaying a note's" do
          let(:note) { @note11 }
        end
        it_behaves_like "displaying a note's" do
          let(:note) { @note12 }
        end
        it_behaves_like "displaying a note's" do
          let(:note) { @note22 }
        end
      end
    end
  end


  describe "video page" do
    before do
      visit video_path(@video)
    end

    it "should have the notes form" do
      expect(page).to have_button("Save Notes")
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
  end

  describe "specialty page" do
    before do
      visit video_path(@video)
      fill_in "note_title", with: @title
      fill_in "note_content", with: @content
      click_button "Save Notes"
      sleep 1.second
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