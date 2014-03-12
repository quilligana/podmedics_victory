require 'spec_helper'

feature 'Static Pages' do

  scenario 'Accessing the home page' do
    visit root_path
    within 'h1' do
      expect(page).to have_content 'We Make Medical Revision Videos'
    end
  end

  scenario 'Accessing the about page' do
    visit root_path
    click_link 'Find out more'
    within '.sub_heading_wrapper' do
      expect(page).to have_content 'About Podmedics'
    end
  end
  
  scenario 'Accessing the FAQs page' do
    visit root_path
    within '.main_nav_wrapper' do
      click_link 'faqs'
    end
    expect(page).to have_content 'Frequently Asked Questions'
  end

  scenario 'Viewing the faqs' do
    faq = create(:faq)
    visit root_path
    within '.main_nav_wrapper' do
      click_link 'faqs'
    end
    expect(page).to have_content faq.title
    expect(page).to have_content faq.content
  end

  scenario 'Accessing the Podcasts page' do
    visit root_path
    within '.main_nav_wrapper' do
      click_link 'our lectures'
    end
    expect(page).to have_content 'Library'
  end

  scenario 'Viewing categories on the videos page' do
    category = create(:category, name: 'Medicine')
    visit library_path
    expect(page).to have_link category.name
  end

  scenario 'Viewing video count for each category on the videos page' do
    category = create(:category, name: 'Medicine')
    specialty = create(:specialty, name: 'Cardiology', category: category)
    video = create(:video, specialty: specialty)
    visit library_path
    within '.library_count' do
      expect(page).to have_content '1 Lecture'
    end
  end

  scenario 'Viewing specialties and videos for a category on the videos page' do
    category = create(:category, name: 'Medicine')
    specialty = create(:specialty, name: 'Cardiology', category: category)
    video = create(:video, specialty: specialty)
    visit library_path
    within '.library_column' do
      expect(page).to have_content specialty.name.upcase
      expect(page).to have_content video.title
    end
  end

  scenario 'Accessing the Terms page' do
    visit root_path
    within '.footer' do
      click_link 'Terms and Conditions'
    end
    expect(page).to have_content 'Terms and Conditions'
  end

  scenario 'Contact' do
    visit root_path
    within '.footer' do
      click_link 'Contact'
    end
    expect(page).to have_content 'Contact Us'
  end

end

