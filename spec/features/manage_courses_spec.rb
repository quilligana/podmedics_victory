require 'spec_helper'

feature 'Manage courses' do

  scenario 'Adding a course' do
    sign_in(create(:admin_user))
    click_link 'Courses'
    click_link 'New Course'
    fill_in 'Title', with: 'HouseOfficer Online'
    fill_in 'Price', with: 30
    fill_in 'Date', with: '2014-05-06'
    fill_in 'Event link', with: 'http://google.com'
    fill_in 'Description', with: 'A really cool course'
    click_button 'Create Course'
    within '.course' do
      expect(page).to have_content 'HouseOfficer Online'
    end
  end

  scenario 'Editing a course' do
    course = create(:course)
    sign_in(create(:admin_user))
    visit admin_courses_path
    within '.course' do
      click_link 'Edit'
    end
    fill_in 'Title', with: 'Another course'
    click_button 'Update Course'
    within '.course' do
      expect(page).to have_content 'Another course'
    end
  end

end
