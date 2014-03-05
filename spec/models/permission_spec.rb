require 'spec_helper'

describe Permission do
  describe 'as guest' do
  
    subject { Permission.new(nil) }

    it "allows access to static pages" do
      expect(subject.allow?('static_pages', 'contact')).to be_true
      expect(subject.allow?('static_pages', 'faqs')).to be_true
      expect(subject.allow?('static_pages', 'home')).to be_true
      expect(subject.allow?('static_pages', 'library')).to be_true
      expect(subject.allow?('static_pages', 'terms')).to be_true
    end

    it "allows access to login/logout" do
      expect(subject.allow?('sessions', 'new')).to be_true
      expect(subject.allow?('sessions', 'create')).to be_true
      expect(subject.allow?('sessions', 'destroy')).to be_true
    end

    it "allows access to registration" do
      expect(subject.allow?('users', 'new')).to be_true
      expect(subject.allow?('users', 'create')).to be_true
    end

  end

  describe 'as a user' do
    subject { Permission.new(create(:user))}

    it "does not allow access to admin dashboard" do
      expect(subject.allow?('admin/dashboards', 'show')).to be_false
    end

    it "allows access to the dashboard" do
      expect(subject.allow?('dashboards', 'show')).to be_true
    end
  end

  describe 'as an admin' do
    subject { Permission.new(create(:admin_user))}

    it "allows admin dashboard access" do
      expect(subject.allow?('admin/dashboards', 'show')).to be_true
    end
    
  end
  
end