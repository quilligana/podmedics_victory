require 'spec_helper'

feature 'Newsletter' do

  scenario "Create a new newsletter" do
    sign_in(create(:admin_user))
    click_link 'Newsletter'
    click_link 'New Newsletter'
    fill_in 'Subject', with: 'Welcome to Podmedics'
    fill_in 'Body Content', with: 'Some HTML content'
    fill_in 'Body Text', with: 'Some simple text'
    click_button 'Create Newsletter'
    expect(page).to have_content 'Welcome to Podmedics'
  end

  scenario 'Editing a newsletter' do
    newsletter = create(:newsletter, subject: 'Blah')
    sign_in(create(:admin_user))
    visit edit_admin_newsletter_path(newsletter)
    fill_in 'Subject', with: 'Blah Blah'
    click_button 'Update Newsletter'
    expect(page).to have_content 'Blah Blah'
  end

  scenario 'Viewing a newsletter' do
    newsletter = create(:newsletter, subject: 'Blah')
    sign_in(create(:admin_user))
    visit admin_newsletter_path(newsletter)
    expect(page).to have_content 'Blah'
  end

  scenario 'Removing a newsletter' do
    newsletter = create(:newsletter, subject: 'Blah')
    sign_in(create(:admin_user))
    visit admin_newsletters_path
    click_link 'Remove'
    expect(page).to_not have_content 'Blah'
  end

end
