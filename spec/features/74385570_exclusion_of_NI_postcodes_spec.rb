require 'spec_helper'

feature 'As a resident from Northern Ireland, I need to know that CF is not applicable to me.' do

  scenario 'NI Postcode should display message saying the country is not serviced by this application' do
    visit '/'
    fill_in 'search-main', with: 'BT80 8QF'
    select 'All law', from: 'Area of law'

    VCR.use_cassette('valid_ni_postcode') do
      click_button 'Search'
    end

    expect(page).to have_content('Northern Ireland is not currently supported by this tool')
  end

end
