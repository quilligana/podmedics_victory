require 'spec_helper'

describe StaticPagesController do

  describe 'GET #home' do
    it 'should be success' do
      get :home
      expect(response).to be_success
    end
  end
  describe 'GET #about' do
    it 'should be success' do
      get :about
      expect(response).to be_success
    end
  end
  describe 'GET #faqs' do
    it 'should be success' do
      get :faqs
      expect(response).to be_success
    end
  end
  describe 'GET #terms' do
    it 'should be success' do
      get :terms
      expect(response).to be_success
    end
  end
  describe 'GET #contact' do
    it 'should be success' do
      get :contact
      expect(response).to be_success
    end
  end
end