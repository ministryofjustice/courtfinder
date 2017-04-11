require 'spec_helper'

feature 'Google Maps links for visiting addresses' do
  let!(:visiting_type) { create(:address_type, :name => "Visiting") }
  let!(:town) { create(:town, :name => "London") }
  let!(:visiting_address ) do
    create(:address,
      :address_line_1 => "Some street",
      :postcode => "CR0 2RB",
      :address_type => visiting_type,
      :town => town)
  end

  let!(:st_albans_county_court) do
    VCR.use_cassette('postcode_found') do
      create(:court, name: 'St Albans County Court',
        addresses: [ visiting_address ])
    end
  end

  scenario 'Enter the site using a /search/:area_of_law will take me to a preselected search' do
    visit "/courts/st-albans-county-court"
    expect(page).to have_content('Maps and directions')
  end
end
