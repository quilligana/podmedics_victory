require File.dirname(__FILE__) + '/../spec_helper'

describe SpecialtyQuestion do

  before do
    @category = create(:category, name: 'Medicine') 
    @specialty = create(:specialty, category: @category)
    @user = create(:user)
    @specialty_question = @specialty.user_questions.create(user: @user, content: "This is a question.")
  end

  subject { @specialty_question }

  it { should respond_to :user }
  it { should respond_to :content }
  it { should respond_to :specialty }
  it { should respond_to :answers }
  it { should respond_to :nested_answers }
  it { should respond_to :comments_count }

  it { should be_valid }

  

end
