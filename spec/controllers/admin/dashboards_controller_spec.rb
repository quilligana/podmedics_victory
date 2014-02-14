require 'spec_helper'

describe Admin::DashboardsController do

  describe "GET 'show' without admin login" do
    it "redirects to login" do
      get 'show'
      expect_redirect_to_login
    end
  end

  describe "GET 'show' with user login" do
    it "redirects to login" do
      set_session_for(create(:user))
      get 'show'
      expect_redirect_to_login
    end
  end

  describe "GET 'show' with admin login" do
    it "shows the dashboard page" do
      set_session_for(create(:admin_user))
      get 'show'
      response.should be_success
    end
  end

  # Helper Methods

  def expect_redirect_to_login
    response.should redirect_to login_path
  end

end
