require 'spec_helper'

describe "omniauth" do

  before do
    generate_plans
  end

  subject { page } 
  
  let(:submit) { "Submit" }

  shared_examples_for 'when the email redirect request is occurring' do
    it "it will ask for the user's email address" do
      expect(page).to have_content "Please enter a valid email address"
    end

    describe 'entering a valid email address' do
      before do
        fill_in 'Email', with: 'mail@example.com'
        update_profile
      end

      it 'will stop redirecting to request an email address' do
        expect(page).to_not have_content "Please enter a valid email address"
      end
    end
  end

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
        
        describe 'Manual Email Request' do
          describe 'immediately after login' do
            it_should_behave_like 'when the email redirect request is occurring'
          end

          describe 'attempting to visit another page' do
            before do
              video = create(:video)
              visit video_path(video)
            end

            it_should_behave_like 'when the email redirect request is occurring'
          end
        end
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