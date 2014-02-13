require 'spec_helper'

feature 'Managing specialties' do
  
  let(:admin_user) { create(:admin_user)}

  scenario 'Adding a specialty' do
    category = create(:category, name: 'Medicine')
    sign_in(admin_user)
    add_specialty_with_name_and_category('Cardiology', category)
    admin_sees_specialty_item_with_name_and_category 'Cardiology', category
  end

  scenario 'Adding a specialty without name' do
    category = create(:category, name: 'Medicine')
    sign_in(admin_user)
    add_specialty_with_name_and_category('', category)
    expect(page).to have_content "can't be blank"
  end

  scenario 'Editing a specialty' do
    category = create(:category, name: 'Medicine')
    another_category  = create(:category, name: 'Surgery')
    specialty = create(:specialty, category: category)
    sign_in(admin_user)
    edit_specialty('General', another_category)
    admin_sees_specialty_item_with_name_and_category('General', another_category)
  end

  scenario 'Removing a specialty' do
    specialty = create(:specialty, category: create(:category))
    sign_in(admin_user)
    admin_removes_specialty
    expect(page).to_not have_content specialty.name
  end

  # Helper methods

  def add_specialty_with_name_and_category(name, category)
    click_link 'Specialties'
    click_link 'New Specialty'
    fill_in 'Name', with: name 
    select category.name, from: 'Category'
    click_button 'Submit'
  end

  def edit_specialty(new_name, category)
    click_link 'Specialties'
    within 'li.specialty' do
      click_link 'Edit'
    end
    fill_in 'Name', with: new_name
    select category.name, from: 'Category'
    click_button 'Submit'
  end

  def admin_removes_specialty
    click_link 'Specialties'
    within 'li.specialty' do
      click_link 'Delete'
    end
  end

  def admin_sees_specialty_item_with_name_and_category(name, category)
    within 'li.specialty' do
      expect(page).to have_content name
      expect(page).to have_css '.category', text: category.name
    end
  end

end
