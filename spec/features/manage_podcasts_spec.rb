require 'spec_helper'

feature 'Managing videos' do
  let(:admin_user) { create(:admin_user) }

  scenario 'Adding a new video' do
    specialty = create(:specialty)
    sign_in(admin_user)
    click_link 'Videos'
    click_link 'New video'
    fill_in 'Title', with: 'The ECG'
    fill_in 'Description', with: 'This is a podcast about ECGs'
    select specialty.name, from: 'Specialty'
    fill_in 'Vimeo Identifier', with: '324567'
    fill_in 'Duration', with: '10'
    click_button 'Submit'

    expect(current_path).to eq admin_videos_path
    expect(page).to have_content 'The ECG'
  end

  scenario  'Editing a video' do
    video = create(:video)
    sign_in(admin_user)
    click_link 'Videos'
    within 'li.video' do
      click_link 'Edit'
    end
    fill_in 'Title', with: 'Heart Failure'
    click_button 'Submit'

    expect(page).to have_content 'Heart Failure'

  end
end
