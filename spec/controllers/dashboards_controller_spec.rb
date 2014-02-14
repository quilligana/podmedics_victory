require 'spec_helper'

describe DashboardsController do

  describe "GET 'show' without user login" do
    it "redirects to login_path" do
      get 'show'
      response.should redirect_to login_path
    end
  end

  describe "GET 'show' with user login" do
    it 'returns http success' do
      set_session_for(create(:user))
      get 'show'
      response.should be_success
    end
  end

end
