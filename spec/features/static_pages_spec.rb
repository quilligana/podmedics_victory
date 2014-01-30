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
    within 'h1' do
      expect(page).to have_content 'About Podmedics'
    end
  end
  
  scenario 'Accessing the FAQs page' do
    visit root_path
    within 'header' do
      click_link 'FAQs'
    end
    expect(page).to have_content 'Frequently asked questions'
  end

  scenario 'Accessing the Podcasts page' do
    visit root_path
    within 'header' do
      click_link 'Our Videos'
    end
  end
end

