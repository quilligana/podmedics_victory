require "spec_helper"

feature 'Manage FAQs' do

  let(:admin_user) { create(:admin_user) }

  before :each do
    sign_in(admin_user)
  end
  
  scenario 'Adding new faq' do
    click_link 'FAQs'
    click_link '+ New FAQ'
    fill_in 'Title', with: 'What does Podmedics cost?'
    fill_in 'Content', with: 'Not much!'
    click_button 'Create Faq'
    expect(page).to have_content 'FAQ added'
  end

  scenario 'Viewing faqs' do
    faq = create(:faq)
    click_link 'FAQs'
    expect(page).to have_content faq.title
  end

  scenario 'Editing faq' do
    faq = create(:faq)
    click_link 'FAQs'
    within 'tr.faq' do
      click_link 'Edit'
    end
    fill_in 'Title', with: 'Another FAQ title'
    click_button 'Update Faq'
    expect(page).to have_content 'Another FAQ title'
  end
end
