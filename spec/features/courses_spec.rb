# Not in use
# require "spec_helper"

# feature 'Courses spec' do

#   scenario 'Viewing the courses page' do
#     user_visits_courses_page
#     expect(page).to have_content 'Podmedics Courses'
#   end

#   scenario 'Viewing dynamic content on the course page' do
#     course = create(:course)
#     user_visits_courses_page
#     expect(page).to have_content course.title
#     expect(page).to have_content course.description
#     expect(page).to have_content course.date.to_s(:long)
#     expect(page).to have_link 'Find out more and book', href: course.event_link
#   end

#   #Helpers

#   def user_visits_courses_page
#     sign_in(create(:user))
#     within '#main_navigation' do
#       click_link 'Courses'
#     end
#   end

# end
