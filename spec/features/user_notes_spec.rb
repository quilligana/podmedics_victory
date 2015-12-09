require 'spec_helper'

describe "notes page" do

  before do
    @user = create(:user)

    @categories = []
    2.times do
      @categories.push create(:category)
    end

    @specialties = []
    @categories.each do |category|
      2.times do
        @specialties.push create(:specialty, category: category)
      end
    end

    @notes = []
    @specialties.each do |specialty|
      @notes.push create(:note, noteable: specialty, user: @user)
    end

    sign_in @user
  end

  describe 'index page' do
    describe 'with no filter' do
      before do
        visit notes_path
      end

      it 'will display all notes' do
        @notes.each do |note|
          expect(page).to have_content note.content
        end
      end
    end

    describe 'specialty filter' do
      before do
        @specialty = @specialties.sample
        visit specialty_notes_path(@specialty)
      end

      it "displays only that specialty's notes" do
        within '.page' do
          @notes.each do |note|
            if note.specialty == @specialty
              expect(page).to have_content note.content
            else
              expect(page).to_not have_content note.content
            end
          end
        end
      end

      it "only displays that specialty's title" do
        within '.page' do
          @specialties.each do |specialty|
            if specialty == @specialty
              expect(page).to have_content specialty.name
            else
              expect(page).to_not have_content specialty.name
            end
          end
        end
      end

      it "displays only that specialty's category's name" do
        within '.page' do
          @categories.each do |category|
            if category == @specialty.category
              expect(page).to have_content category.name
            else
              expect(page).to_not have_content category.name
            end
          end
        end
      end


    end

    describe 'category filter' do
      before do
        @category = @categories.sample
        visit category_notes_path(@category)
      end

      it "displays only that category's notes" do
        within '.page' do
          @notes.each do |note|
            if note.category == @category
              expect(page).to have_content note.content
            else
              expect(page).to_not have_content note.content
            end
          end
        end
      end

      it "only displays that category's specialties' titles" do
        within '.page' do
          @specialties.each do |specialty|
            if specialty.category == @category
              expect(page).to have_content specialty.name
            else
              expect(page).to_not have_content specialty.name
            end
          end
        end
      end

      it "displays only that category's name" do
        within '.page' do
          @categories.each do |category|
            if category == @category
              expect(page).to have_content category.name
            else
              expect(page).to_not have_content category.name
            end
          end
        end
      end

    end
  end
end
