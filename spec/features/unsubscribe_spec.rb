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

    describe 'with an email that does not exist' do
      before do
        User.destroy_all
        fill_in 'unsub_email', with: 'mail@example.com'
        click_button 'Unsubscribe'
      end

      it 'does not correct the user' do
        expect(page).to have_content 'mail@example.com has been unsubscribed'
      end
    end
  end
end