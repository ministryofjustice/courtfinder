require 'spec_helper'

feature 'Related links for court pages' do
  let!(:money_claims_area) { create(:area_of_law, id: 418, name: 'Money claims')}
  let!(:county_court_type) { create(:court_type, id: 31, name: 'County court') }
  let!(:court) { create(:court, 
                        name: 'Liverpool Civil and Family Court', 
                        areas_of_law: [money_claims_area], 
                        court_types: [county_court_type]) }

  scenario 'Go to a court page and it should have a link to GOV.UK under related links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk']") 
  end

  scenario 'A Court dealing with Money Claims should have relavent links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/make-court-claim-for-money']") 
  end

  scenario 'A Court type of County court should have relavent links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='http://www.civilmediation.org/']") 
  end

  scenario 'A Court that is not a type of Family court should not have relavent links for it' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_no_xpath("//*/a[@href='http://www.familymediationcouncil.org.uk/']") 
  end

end