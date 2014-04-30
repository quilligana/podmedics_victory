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
      expect(subject.allow?('static_pages', 'about')).to be_true
    end

    it "allows access to login/logout" do
      expect(subject.allow?('sessions', 'new')).to be_true
      expect(subject.allow?('sessions', 'create')).to be_true
      expect(subject.allow?('sessions', 'destroy')).to be_true
      expect(subject.allow?('sessions', 'omniauthcreate')).to be_true
    end

    it "allows access to registration" do
      expect(subject.allow?('users', 'new')).to be_true
      expect(subject.allow?('users', 'create')).to be_true
    end

    it "allows access to courses" do
      expect(subject.allow?('courses', 'index')).to be_true
    end

    it "allows password recovery" do
      expect(subject.allow?('password_resets', 'create')).to be_true
      expect(subject.allow?('password_resets', 'edit')).to be_true
      expect(subject.allow?('password_resets', 'update')).to be_true
    end

  end

  describe 'as a user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    subject { Permission.new(user)}

    it "does not allow access to admin dashboard" do
      expect(subject.allow?('admin/dashboards', 'show')).to be_false
    end

    it "allows access to the dashboard" do
      expect(subject.allow?('dashboards', 'show')).to be_true
    end

    it "allows access to the profile page" do
      expect(subject.allow?('users', 'show')).to be_true
    end

    it "allows access to edit your own profile page" do
      expect(subject.allow?('users', 'edit', user)).to be_true
    end

    it "does not allow you to edit profiles of other users" do
      expect(subject.allow?('users', 'edit', another_user)).to be_false
    end

    it "allows access to the video page" do
      expect(subject.allow?('videos', 'show')).to be_true
    end

    it "allows video downloads" do
      expect(subject.allow?('hosted_files', 'video')).to be_true
      expect(subject.allow?('hosted_files', 'audio')).to be_true
      expect(subject.allow?('hosted_files', 'slides')).to be_true
    end

    it "allows access to the specialties page" do
      expect(subject.allow?('specialties', 'show')).to be_true
    end

    it "allows access to the video/questions pages" do
      expect(subject.allow?('questions', 'index')).to be_true
      expect(subject.allow?('questions', 'show')).to be_true
      expect(subject.allow?('questions', 'answer')).to be_true
      expect(subject.allow?('questions', 'result')).to be_true
      expect(subject.allow?('questions', 'specialty_index')).to be_true
    end

    it "allows commenting" do
      expect(subject.allow?('comments', 'create')).to be_true
      expect(subject.allow?('comments', 'vote')).to be_true
      expect(subject.allow?('comments', 'accept')).to be_true
    end

    it "allows viewing, creation and removal of specialty questions" do
      expect(subject.allow?('specialty_questions', 'show')).to be_true
      expect(subject.allow?('specialty_questions', 'index')).to be_true
      expect(subject.allow?('specialty_questions', 'create')).to be_true
      expect(subject.allow?('specialty_questions', 'destroy')).to be_true
    end
  end

  describe 'as an admin' do
    subject { Permission.new(create(:admin_user))}

    it "allows admin dashboard access" do
      expect(subject.allow?('admin/dashboards', 'show')).to be_true
    end
    
  end
  
end
