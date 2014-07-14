require 'spec_helper'

feature 'Google Maps links for visiting addresses' do
  let!(:visiting_type) { create(:address_type, :name => "Visiting") }
  let!(:town) { create(:town, :name => "London") }
  let!(:visiting_address ) { create(:address, 
                                    :address_line_1 => "Some street", 
                                    :postcode => "CR0 2RB", 
                                    :address_type => visiting_type, 
                                    :town => town) }

  let!(:st_albans_county_court) { create( :court, name: 'St Albans County Court', 
                                          addresses: [ visiting_address ]) }

  scenario 'Enter the site using a /search/:area_of_law will take me to a preselected search' do
    visit "/courts/st-albans-county-court"
    expect(page).to have_content('Click here for maps and directions')
  end
end
