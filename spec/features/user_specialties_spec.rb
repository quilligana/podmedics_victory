require 'spec_helper'

feature 'User Specialties' do

  scenario 'Viewing a specialty page' do
    specialty = create(:specialty, name: 'Cardiology')
    video = create(:video, specialty: specialty)
    sign_in(create(:user))
    visit video_path(video)
    click_link specialty.name
    expect(page).to have_content specialty.name

  end
end
