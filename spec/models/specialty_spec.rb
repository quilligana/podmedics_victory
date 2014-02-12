require 'spec_helper'

describe Specialty do
  it { should belong_to :category}
end

describe Specialty, '#category_name' do
  it "delegate to category for name" do
    category = create(:category, name: 'Medicine') 
    specialty = create(:specialty, category: category)
    expect(specialty.category_name).to eq category.name
  end
end
