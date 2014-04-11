require 'spec_helper'

feature 'Manage categories in the admin' do
  
  let(:admin_user) { create(:admin_user) }

  scenario 'Viewing categories' do
    category = create(:category, name: 'Medicine')
    another_category = create(:category, name: 'Surgery')
    sign_in(admin_user)
    visit_categories_index
    expect(page).to have_css 'tr.category', text: category.name
    expect(page).to have_css 'tr.category', text: another_category.name
  end

  scenario 'Adding a new category' do
    sign_in(admin_user)
    visit_categories_index
    create_category_with_name 'Medicine'
    expect(page).to have_content 'New Category added'
  end

  scenario 'Adding a new category without a name' do
    sign_in(admin_user)
    visit_categories_index
    create_category_with_name ''
    expect(page).to have_content "can't be blank"
  end

  scenario 'Editing a category' do
    category = create(:category, name: 'Medicine')
    sign_in(admin_user)
    visit_categories_index
    update_category_with_name 'Surgery'
    expect(page).to have_css 'tr.category', text: 'Surgery'
  end

  # Helper methods

  def create_category_with_name(name)
    click_link 'New Category'
    fill_in 'Name', with: name
    click_button 'Create Category'
  end

  def visit_categories_index
    click_link 'Categories'
  end

  def update_category_with_name(name)
    within 'tr.category' do click_link 'Edit' end

    fill_in 'Name', with: name
    click_button 'Update Category'
  end

end
