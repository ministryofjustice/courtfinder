require 'spec_helper'

feature 'update court with unrecognised postcode' do
  let(:town) { create :town, name: 'London' }
  let(:address_type) { create :address_type, name: 'Visiting' }
  let(:address) { create :address, address_line_1: '10 Downing Street', town: town, postcode: 'SW1A 2AA', address_type_id: address_type.id }

  before do
    visit '/admin'
    sign_in create(:user)

    # MapIt recognises the old postcode
    stub_request(:get, 'http://mapit.mysociety.org/postcode/SW1A+2AA').
      to_return status: 200, body: '{"wgs84_lat": 51.50353968541332, "wgs84_lon": -0.12769524464003412}'

    court = create :court, addresses: [address] # the latitude/longitude gets looked up here
    visit edit_admin_court_path(court)
  end

  scenario 'edit unrelated details for a court with a postcode that MapIt can no longer geocode' do
    # Now MapIt doesn't recognise the old postcode
    stub_request(:get, 'http://mapit.mysociety.org/postcode/SW1A+2AA').
      to_return status: 404, body: '{"code": 404, "error": "No Postcode matches the given query."}'

    fill_in 'Crown Court code', with: '42'
    click_on 'Update'

    expect(page).to have_content('Court was successfully updated.')
  end

  pending scenario 'be prevented from changing an old postcode to a new one that MapIt can\'t geocode' do
    # MapIt doesn't recognise the new postcode
    stub_request(:get, 'http://mapit.mysociety.org/postcode/SW1A+2AB').
      to_return status: 404, body: '{"code": 404, "error": "No Postcode matches the given query."}'

    click_on 'Addresses'
    fill_in 'Postcode', with: 'SW1A 2AB'
    click_on 'Update'

    expect(page).to have_content('errors prohibited this court from being saved')
    expect(page).to have_content('Latitude can\'t be blank')
    expect(page).to have_content('Longitude can\'t be blank')
  end

  scenario 'change an old postcode to a new one that MapIt can geocode' do
    # MapIt recognises the new postcode
    stub_request(:get, 'http://mapit.mysociety.org/postcode/SW1A+2AB').
      to_return status: 200, body: '{"wgs84_lat": 51.503398657406, "wgs84_lon": -0.12787393254000892}'

    click_on 'Addresses'
    fill_in 'Postcode', with: 'SW1A 2AB'
    click_on 'Update'

    expect(page).to have_content('Court was successfully updated.')
  end
end
