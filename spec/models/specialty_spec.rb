# == Schema Information
#
# Table name: specialties
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  professor   :integer
#

require 'spec_helper'

describe Specialty do
  it { should respond_to :slug }
  it { should respond_to :professor }
  it { should belong_to :category}
  it { should validate_presence_of :name}
  it { should have_many :videos }
  it { should have_many :questions }
  it { should have_many :specialty_questions }
  it { should have_many :notes }
  it { should have_many :direct_notes }
  it { should have_many :exams }
  it { should have_many :badges }
  it { should have_many :user_questions }
  it { should have_many :unlocked_specialties }
  it { should have_many(:users).through(:unlocked_specialties) }

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

  describe Specialty, '#question_status and #question_target' do
    it "should return red if the specialty has less than 7 questions per video" do
      specialty = create(:specialty)
      videos = create_list(:video, 5, specialty: specialty)
      expect(specialty.question_status).to eq 'red'
      expect(specialty.question_target).to eq 35
    end
  end

  describe Specialty, '#is_unlocked_for_user' do
    it "returns true if the specialty is unlocked" do
      user = create(:user)
      specialty = create(:specialty)
      unlocked_specialty = create(:unlocked_specialty, user: user, specialty: specialty)
      expect(specialty.is_unlocked_for_user?(user)).to be_true
    end

    it "returns false if the specialty is not unlocked" do
      user = create(:user)
      specialty = create(:specialty)
      expect(specialty.is_unlocked_for_user?(user)).to be_false
    end
  end
end
