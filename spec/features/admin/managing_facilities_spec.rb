require 'spec_helper'

feature 'As an admin I should be able to manage facility' do
  let!(:user) { create(:user) }

  before do
    visit '/admin'
    sign_in user
  end

  it 'I am able to create facility' do
    visit new_admin_facility_path

    expect(page).to have_content('New facility_type')
    fill_in('Name', with: 'Baby')
    fill_in('Image description', with: 'Baby change')
    expect(page).not_to have_xpath('.//input[@id="facility_image"]')

    image_path = "#{ Rails.root }/spec/fixtures/assets/firstaid.png"
    attach_file('facility_image_file', image_path)
    click_button "Create Facility"

    expect(page).to have_content('Facility type was successfully created.')

    expect(page).to have_content('Name: Baby')
    expect(page).to have_content('Image description: Baby change')
    expect(page).to have_xpath('.//img[@title="Baby change"]')
  end

  it 'I am able to update facility' do
    file = File.open("#{ Rails.root }/spec/fixtures/assets/firstaid.png")
    facility = create(:facility, name: 'baby', image_file: file)

    visit edit_admin_facility_path(facility)

    expect(page).to have_content('Editing facility')
    fill_in('Name', with: 'Hotspot')
    fill_in('Image description', with: 'Wifi is available')
    expect(page).not_to have_xpath('.//input[@id="facility_image"]')

    attach_file('facility_image_file', "#{ Rails.root }/spec/fixtures/assets/hotspot.png")
    click_button "Update Facility"

    expect(page).to have_content('Facility type was successfully updated.')

    expect(page).to have_content('Name: Hotspot')
    expect(page).to have_content('Image description: Wifi is available')
    expect(page).to have_xpath('.//img[@title="Wifi is available"]')
    expect(page.find(:xpath, './/img[@title="Wifi is available"]')['src']).to include('hotspot.png')
  end
end
