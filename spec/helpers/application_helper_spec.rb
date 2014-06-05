require 'spec_helper'

describe ApplicationHelper do

  describe 'user_points' do
    let(:the_user) {FactoryGirl.create(:user)}

    it 'should return the current users points' do
      expect(the_user.points).to eq(0)
      the_user.add_points(:correct_answer)
      expect(the_user.points).to eq(10)
    end
  end

end
