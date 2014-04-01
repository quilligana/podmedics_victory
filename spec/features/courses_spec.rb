require "spec_helper"

feature 'Courses spec' do

  scenario 'Viewing the courses page' do
    sign_in(create(:user))
    within '#main_navigation' do
      click_link 'Courses'
    end
    expect(page).to have_content 'Our Courses'
  end
end
