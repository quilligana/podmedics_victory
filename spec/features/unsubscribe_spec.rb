require "spec_helper"
include UnsubscribeMacros

describe 'Unsubscribing' do

  before do
    @user = create(:user)
  end

  describe 'unsubscribe page' do
    before do
      visit unsubscribe_path
    end

    describe 'the form presented to users' do
      it 'will request an email address' do
        expect(page).to have_field 'unsub_email'
      end

      describe 'checkboxes are present and unchecked by default' do
        EMAIL_TYPES.each do |email_type|
          checkbox_check(email_type)
        end
      end
    end

  end

  describe 'clicking the unsubscribe link in an email' do
    before do
      visit unsubscribe_token_url(@user.unsubscribe_token)
    end

    it 'will fill in the forms email field' do
      expect(find(:field, 'unsub_email').value).to eq @user.email
    end
  end

  describe 'unsubscribing' do
    before do 
      visit unsubscribe_path
    end

    describe 'with a valid email' do
      before do
        fill_in 'unsub_email', with: @user.email
      end

      describe 'unsubscribing from each type email individually' do
        EMAIL_TYPES.each do |email_type|
          unsubscribe_check(email_type)
        end
      end
    end

    describe 'with a user that is not found by searching for a token' do
      it "should redirect to home page with a message" do
        no_user_token = '123456789'
        visit unsubscribe_token_url(no_user_token)
        expect(page).to have_content 'Sorry. Your account was not found.'
      end
    end
  end

end
