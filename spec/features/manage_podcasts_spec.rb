require 'spec_helper'

feature 'Managing videos' do
  let(:admin_user) { create(:admin_user) }

  scenario 'Adding a new video' do
    specialty = create(:specialty)
    sign_in(admin_user)
    add_podcast_with_name_and_specialty('The ECG', specialty)
    admin_sees_podcast_name 'The ECG'
  end

  scenario  'Editing a video' do
    video = create(:video)
    sign_in(admin_user)
    edit_podcast_to_name 'Heart Failure'
    admin_sees_podcast_name 'Heart Failure'
  end

  scenario 'Viewing a video' do
    video = create(:video)
    sign_in(admin_user)
    click_link 'Videos'
    within 'tr.video' do
      click_link 'Show'
    end
    expect(page).to have_content video.title
    expect(page).to have_content video.description
    expect(page).to have_content video.duration
  end

  scenario 'Moving up in position' do
    specialty = create(:specialty)
    video_1 = create(:video, specialty: specialty, position: 1)
    video_2 = create(:video, specialty: specialty, position: 2)
    sign_in(admin_user)
    visit admin_specialty_path(specialty)
    within "#2" do
      click_link 'Up'
    end
    within '#2' do
      expect(page).to have_content 1
    end
    video_2.reload
    expect(video_2.position).to eq 1
  end

  scenario 'Moving up in position' do
    specialty = create(:specialty)
    video_1 = create(:video, specialty: specialty, position: 1)
    video_2 = create(:video, specialty: specialty, position: 2)
    sign_in(admin_user)
    visit admin_specialty_path(specialty)
    within "#1" do
      click_link 'Down'
    end
    within '#1' do
      expect(page).to have_content 2
    end
    video_1.reload
    expect(video_1.position).to eq 2
  end

  # Helpers
  
  def add_podcast_with_name_and_specialty(name, specialty)
    click_link 'Videos'
    click_link 'New video'
    fill_in 'Title', with: name
    fill_in 'Description', with: 'This is a podcast about ECGs'
    select specialty.name, from: 'Specialty'
    fill_in 'Vimeo Identifier', with: '324567'
    fill_in 'Download file name', with: 'test_file'
    fill_in 'Duration', with: '10'
    click_button 'Submit'
  end

  def edit_podcast_to_name(name)
    click_link 'Videos'
    within 'tr.video' do
      click_link 'Edit'
    end
    fill_in 'Title', with: name
    click_button 'Submit'
  end

  def admin_sees_podcast_name(name)
    expect(page).to have_content name
  end
end
