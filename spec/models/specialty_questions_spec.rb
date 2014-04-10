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
  it { should respond_to :comments_count }
  it { should respond_to :get_answers }
  it { should respond_to :comments_count }
  it { should respond_to :accept_answer }
  it { should respond_to :accepted_answer }
  it { should respond_to :accept_answer }
  it { should respond_to :already_accepted_answer? }
  it { should have_many :answers }
  it { should have_many :nested_answers }

  it { should be_valid }

end
