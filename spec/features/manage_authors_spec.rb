require 'spec_helper'

feature 'Manage authors' do

  scenario 'Add an author' do
    admin_navigates_to_authors
    click_link 'New Author'
    fill_in 'Name', with: 'John Smith'
    fill_in 'Tagline', with: 'Podmedics Poet Laureat'
    fill_in 'Twitter', with: 'podmedicsjohn'
    fill_in 'Facebook', with: 'http://facebook.com/podmedicsjohn'
    click_button 'Create Author'

    within '.authors' do
      expect(page).to have_content 'John Smith'
    end
  end

  scenario 'Update an author' do
    author = create(:author)
    admin_navigates_to_authors
    within '.author' do
      click_link 'Edit'
    end
    fill_in 'Tagline', with: 'Podmedics Surgical Director'
    click_button 'Update Author'

    expect(current_path).to eq admin_author_path(author)
    expect(page).to have_content author.name
    expect(page).to have_content 'Podmedics Surgical Director'
  end

  # Helpers

  def admin_navigates_to_authors
    sign_in(create(:admin_user))
    click_link 'Authors'
  end

end
