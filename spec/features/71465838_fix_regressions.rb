require 'spec_helper'

feature 'Fix regressions on courtfinder' do

  let!(:area_of_law) { create(:area_of_law, name: 'Divorce', type_divorce: true)}
  let!(:court) { create(:) }

  scenario 'Postcode and area of law should be visible in query string' do
    visit '/'
    fill_in 'Postcode', with: 'SW11 4BG'
    select 'Divorce', from: 'Area of law'
    
    click_button 'Search'
  end

  scenario 'Postcode should be displayed in query string as from=<postcode> in court link' do

  end

end