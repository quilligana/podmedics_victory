require 'spec_helper'

describe ApplicationHelper do

  describe 'nav_link' do
    it "should have a title" do
      expect(valid_nav_link).to match /Test title/
    end

    it "should have target" do
      expect(valid_nav_link).to match /href="test_path"/
    end
  end

  describe 'selected class' do
    
    it "is the current page" do
      allow(helper).to receive(:current_page?) { true }
      expect(valid_nav_link).to match /class="selected"/ 
    end

    it "is not the current page" do
      allow(helper).to receive(:current_page?) { false }
      expect(valid_nav_link).to_not match /class="selected"/
    end
  end

  describe 'user_points' do
    let(:the_user) {FactoryGirl.create(:user)}

    it 'should return the current users points' do
      expect(the_user.points).to eq(0)
      the_user.add_points(:correct_answer)
      expect(the_user.points).to eq(10)
    end
  end

  # Helper methods
  def valid_nav_link
    helper.nav_link('Test title', 'test_path')
  end

end
