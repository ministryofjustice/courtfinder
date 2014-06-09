require 'spec_helper'

feature 'Check the Money (MCOL) / Possession (PCOL) Claims paragraphs no longer show on Court pages' do

  let!(:money_claims_area) { create(:area_of_law, id: 418, name: 'Money claims') }
  let!(:county_court_type) { create(:court_type, id: 31, name: 'County Court') }
  let!(:st_albans_county_court) { create(:court, name: 'St Albans County Court', areas_of_law: [money_claims_area], court_types: [county_court_type]) }

  scenario 'Check MCOL paragraph has gone' do
    visit '/courts/st-albans-county-court'
    expect(page).to have_no_content("(eg a small claim), if someone owes you money.")
  end

  scenario 'Check PCOL paragraph has gone' do
    visit '/courts/st-albans-county-court'
    expect(page).to have_no_content("to repossess a property or evict a tenant.")
    save_and_open_page
  end    
end