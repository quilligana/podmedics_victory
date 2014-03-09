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
      click_link 'FAQs'
    end
    expect(page).to have_content 'Podmedics FAQs'
  end

  scenario 'Accessing the Podcasts page' do
    visit root_path
    within '.main_nav_wrapper' do
      click_link 'Our Videos'
    end
    expect(page).to have_content 'Library'
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

