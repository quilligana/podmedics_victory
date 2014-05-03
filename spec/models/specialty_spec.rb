require 'spec_helper'

describe Specialty do
  it { should respond_to :slug }
  it { should respond_to :professor }
  it { should belong_to :category}
  it { should validate_presence_of :name}
  it { should have_many :videos }
  it { should have_many :questions }

  describe Specialty, '#category_name' do
    it "delegates to category for name" do
      category = create(:category, name: 'Medicine') 
      specialty = create(:specialty, category: category)
      expect(specialty.category_name).to eq category.name
    end
  end

  describe Specialty, '#change_professor' do
    it "changes the professor of the specialty to the new professor" do
      specialty = create(:specialty, professor: 20)
      specialty.change_professor(1)
      expect(specialty.professor).to eq(1)
    end
  end
end
