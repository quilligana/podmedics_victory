require 'spec_helper'

feature 'Managing specialties' do
  
  let(:admin_user) { create(:admin_user)}

  scenario 'Adding a specialty' do
    category = create(:category, name: 'Medicine')
    sign_in(admin_user)
    click_link 'Specialties'
    click_link 'New Specialty'
    fill_in 'Name', with: 'Cardiology'
    select 'Medicine', from: 'Category'
    click_button 'Submit'
    within 'li.specialty' do
      expect(page).to have_content 'Cardiology'
    end
  end

  scenario 'Editing a specialty' do
    category = create(:category, name: 'Medicine')
    another_category  = create(:category, name: 'Surgery')
    specialty = create(:specialty, category: category)
    sign_in(admin_user)
    click_link 'Specialties'
    within 'li.specialty' do
      click_link 'Edit'
    end
    fill_in 'Name', with: 'General'
    select 'Surgery', from: 'Category'
    click_button 'Submit'
    within 'li.specialty' do
      expect(page).to have_css '.category', text: 'Surgery'
    end
  end
end
