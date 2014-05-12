require 'spec_helper'

describe 'Plan Selection' do

  before do
    generate_plans
    @user = create(:user)
    @no_plan_user = create(:no_plan_user)
  end

  shared_examples_for 'when a redirect happens' do
    it 'should display payment plans' do
      expect(page).to have_content 'Choose the plan that suites you best.'
    end
  end

  shared_examples_for "when a redirect doesn't happen" do
    it 'should not display payment plans' do
      expect(page).to_not have_content 'Choose the plan that suites you best.'
    end
  end

  describe 'Plan Page Redirection' do
  	describe 'Without a plan selected' do
      before do
        sign_in @no_plan_user
      end
  	  
      describe 'Login redirect' do
        it_should_behave_like 'when a redirect happens'
      end
  
      describe 'Dashboard' do
        before do
          visit dashboard_path
        end
  
        it_should_behave_like 'when a redirect happens'
      end
  
      describe 'Video pages' do
        before do
          @video = create(:video)
          visit video_path(@video)
        end
  
        it_should_behave_like 'when a redirect happens'
      end
  
      describe '@user pages' do
        before do
          visit user_path(@no_plan_user)
        end
  
        it_should_behave_like 'when a redirect happens'
      end
    end

    describe 'With a plan selected' do
   	  before do 
        sign_in @user
      end

      describe 'Login redirect' do
        it_should_behave_like "when a redirect doesn't happen"
      end
  
      describe 'Dashboard' do
        before do
          visit dashboard_path
        end
  
        it_should_behave_like "when a redirect doesn't happen"
      end
  
      describe 'Video pages' do
        before do
          @video = create(:video)
          visit video_path(@video)
        end
  
        it_should_behave_like "when a redirect doesn't happen"
      end
  
      describe '@user pages' do
        before do
          visit user_path(@user)
        end
  
        it_should_behave_like "when a redirect doesn't happen"
      end
    end
  end

  describe 'selecting a plan' do
  	before do
  	  sign_in @no_plan_user
  	end

  	it_should_behave_like 'when a redirect happens'

  	describe 'choosing the free plan' do
  	  before do
  	    within '#free_trial' do
  	      click_on 'Choose Plan'
  	    end
  	  end

  	  it_should_behave_like "when a redirect doesn't happen"
  	end
  end
end