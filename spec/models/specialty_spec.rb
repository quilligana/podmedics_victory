require 'spec_helper'

describe Specialty do
  it { should respond_to :slug }
  it { should belong_to :category}
  it { should validate_presence_of :name}
  it { should have_many :videos }
  it { should have_many :questions }
end

describe Specialty, '#category_name' do
  it "delegate to category for name" do
    category = create(:category, name: 'Medicine') 
    specialty = create(:specialty, category: category)
    expect(specialty.category_name).to eq category.name
  end
end
