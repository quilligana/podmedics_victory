require 'spec_helper'

feature 'Manage categories in the admin' do
  
  let(:admin_user) { create(:admin_user) }

  scenario 'Viewing single categories' do
    category = create(:category, name: 'Medicine')
    sign_in(admin_user)
    click_link 'Categories'
    expect(page).to have_css 'li.category', text: category.name
  end

  scenario 'Viewing multiple categories' do
    category = create(:category, name: 'Medicine')
    another_category = create(:category, name: 'Surgery')

    sign_in(admin_user)
    click_link 'Categories'
    expect(page).to have_css 'li.category', text: category.name
    expect(page).to have_css 'li.category', text: another_category.name
  end

  scenario 'Adding a new category' do
    sign_in(admin_user)
    visit admin_categories_path
    click_link 'New category'
    fill_in 'Name', with: 'Clinical Specialties'
    click_button 'Submit'
    expect(page).to have_content 'New Category added'
  end

  scenario 'Editing a category' do
    category = create(:category, name: 'Medicine')
    sign_in(admin_user)
    visit admin_categories_path
    within 'li.category' do
      click_link 'Edit'
    end

    fill_in 'Name', with: 'Surgery'
    click_button 'Submit'
    expect(page).to have_css 'li.category', text: 'Surgery'
  end

end
