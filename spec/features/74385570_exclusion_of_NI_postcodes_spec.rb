require 'spec_helper'

feature 'As a resident from Northern Ireland, I need to know that CF is not applicable to me.' do

  context 'Display message saying that Northern Ireland is not serviced by this application' do
    scenario 'when the postcode is in uppercase' do
      visit '/'
      fill_in 'search-main', with: 'BT80 8QF'
      select 'All law', from: 'Area of law'

      VCR.use_cassette('valid_ni_postcode') do
        click_button 'Search'
      end

      expect(page).to have_content('Northern Ireland is not supported by this tool')
    end

    scenario 'when the postcode is in lowercase' do
      visit '/'
      fill_in 'search-main', with: 'bt80 8qf'
      select 'All law', from: 'Area of law'

      VCR.use_cassette('valid_ni_postcode') do
        click_button 'Search'
      end

      expect(page).to have_content('Northern Ireland is not supported by this tool')
    end

    scenario 'then a partial postcode is entered' do
      visit '/'
      fill_in 'search-main', with: 'bt80'
      select 'All law', from: 'Area of law'

      VCR.use_cassette('valid_ni_postcode') do
        click_button 'Search'
      end

      expect(page).to have_content('Northern Ireland is not supported by this tool')
    end
  end

end
