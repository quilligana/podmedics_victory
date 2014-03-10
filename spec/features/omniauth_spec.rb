require 'spec_helper'

describe "omniauth" do

  subject { page } 
  
  let(:submit) { "Submit" }

  describe "twitter" do
    describe "login" do
      before do
        visit login_path
        mock_twitter_auth_hash()
      end

      it { should have_content "Log In via Twitter" }

      describe "can log in user with Twitter account" do
        before { click_link "Log In via Twitter" }

        it { should have_link("Logout") }
      end

      describe "can handle authentication error" do
        before do
          OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
          click_link "Log In via Twitter"
        end

        it { should have_content 'Not authorised' }
      end
    end

    describe "signup" do
      before do
        visit signup_path
        mock_twitter_auth_hash()
      end

      it { should have_content "Sign up via Twitter" }

      describe "can sign up user with Twitter account" do
        before { click_link "Sign up via Twitter" }

        it { should have_link("Logout") }
      end

      describe "can handle authentication error" do
        before do
          OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
          click_link "Sign up via Twitter"
        end

        it { should have_content 'Not authorised' }
      end
    end
  end

  describe "facebook" do
    describe "login" do
      before do
        visit login_path
        mock_facebook_auth_hash()
      end

      it { should have_content "Log In via Facebook" }

      describe "can log in user with Facebook account" do
        before { click_link "Log In via Facebook" }

        it { should have_link("Logout") }
      end

      describe "can handle authentication error" do
        before do
          OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
          click_link "Log In via Facebook"
        end

        it { should have_content 'Not authorised' }
      end
    end

    describe "signup" do
      before do
        visit signup_path
        mock_facebook_auth_hash()
      end

      it { should have_content "Sign up via Facebook" }

      describe "can sign up user with Facebook account" do
        before { click_link "Sign up via Facebook" }

        it { should have_link("Logout") }
      end

      describe "can handle authentication error" do
        before do
          OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
          click_link "Sign up via Facebook"
        end

        it { should have_content 'Not authorised' }
      end
    end
  end
end