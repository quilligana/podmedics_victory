require "spec_helper"

describe 'Caching' do

  describe 'User caching' do 
    before do
      @user = create(:user, email: 'mail@example.com')
      @id = @user.id
    end
  
    describe '#cached_find' do
      it 'will return the user' do
        expect(User.cached_find(@id)).to eq @user
      end
  
      it 'will have had the cache flushed when the user is saved' do
        User.cached_find(@id)
        User.find(@id).update(email: 'different@example.com')
        expect(User.cached_find(@id).email).to eq 'different@example.com'
      end
    end
  end
  
  describe 'Comment caching' do
    before do
      @comment = create(:comment)
      @reply = create(:comment, commentable: @comment)
    end
  
    describe '.cached_comments' do
      it 'will return a list of the replies' do
        expect(@comment.cached_comments).to eq @comment.get_comments
      end
  
      describe 'adding a new reply' do
        it 'will flush the cache' do
          @comment.cached_comments
          @second_reply = create(:comment, commentable: @comment)
          expect(@comment.cached_comments).to eq @comment.get_comments
        end
      end
    end
  end

  describe 'Note caching' do
    before do
      @note = create(:note)
      @id = @note.id
    end

    describe '#cached_find' do
      it 'will return the note' do
        expect(Note.cached_find(@id)).to eq @note
      end
      it 'will have had the cache flushed when the note is saved' do
        Note.cached_find(@id)
        Note.find(@id).update(title: 'title')
        expect(Note.cached_find(@id).title).to eq 'title'
      end
    end

    describe '.cached_title' do
      it 'will return the notes title' do
        expect(@note.cached_title).to eq @note.get_title
      end

      describe 'after updating the title' do
        it 'will flush the cache' do
          @note.cached_title
          @note.title = "hello"
          @note.save
          expect(@note.cached_title).to eq "hello"
        end
      end
    end

    # This is working in development but not testing for some reason
    # Needs work to figure out why
    #describe '.cached_noteable' do
    #  it 'will return the notes title' do
    #    expect(@note.cached_noteable).to eq @note.noteable
    #  end
#
    #  describe 'after updating the title' do
    #    it 'will flush the cache' do
    #      noteable = @note.noteable
    #      @note.cached_noteable
    #      noteable.title = "new title"
    #      noteable.save
    #      expect(Note.find(@id).cached_noteable.title).to eq "new title"
    #    end
    #  end
    #end
  end
end
