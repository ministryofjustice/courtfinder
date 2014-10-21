require 'spec_helper'

feature 'update court with unrecognised postcode' do
  before do
    visit '/admin'
    sign_in create(:user)
  end

  scenario 'edit the details for a court with a postcode that MapIt can no longer geocode' do
    # First MapIt recognises the postcode
    stub_request(:get, 'http://mapit.mysociety.org/postcode/SW1A+2AA').to_return status: 200, body: '{"wgs84_lat": 51.50353968541332, "wgs84_lon": -0.12769524464003412}'

    town = create :town, name: 'London'
    address_type = create :address_type, name: 'Visiting'
    address = create :address, address_line_1: '10 Downing Street', town: town, postcode: 'SW1A 2AA', address_type_id: address_type.id
    court = create :court, addresses: [address]

    # Now MapIt doesn't recognise the postcode
    stub_request(:get, 'http://mapit.mysociety.org/postcode/SW1A+2AA').to_return status: 404, body: '{"code": 404, "error": "No Postcode matches the given query."}'

    visit edit_admin_court_path(court)
    fill_in 'Court number', with: '42'
    click_on 'Update'

    expect(page).to have_content('Court was successfully updated.')
  end
end
