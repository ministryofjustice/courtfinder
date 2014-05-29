require 'spec_helper'

feature 'Related links for court pages' do
  let!(:money_claims_area) { create(:area_of_law, id: 418, name: 'Money claims')}
  let!(:repossessions_area) { create(:area_of_law, id: 407, name: 'Repossessions)')}
  let!(:divorce_area) { create(:area_of_law, id: 356, name: 'Divorce')}
  let!(:adoption_area) { create(:area_of_law, id: 345, name: 'Adoption')}
  let!(:probate_area) { create(:area_of_law, id: 360, name: 'Probate')}
  let!(:bankruptcy_area) { create(:area_of_law, id: 348, name: 'Bankruptcy')}

  let!(:county_court_type) { create(:court_type, id: 31, name: 'County court') }
  let!(:family_court_type) { create(:court_type, id: 35, name: 'Family court') }
  let!(:probate_court_type) { create(:court_type, id: 36, name: 'Probate court') }
  let!(:high_court_type) { create(:court_type, id: 37, name: 'High court') }

  let!(:liverpool_court) { create(:court, 
                        name: 'Liverpool Civil and Family Court', 
                        areas_of_law: [money_claims_area, repossessions_area], 
                        court_types: [county_court_type]) }
  
  let!(:barnstaple_court) { create(:court, 
                        name: 'Barnstaple Crown Court', 
                        areas_of_law: [divorce_area, adoption_area], 
                        court_types: [family_court_type]) }

  let!(:london_court) { create(:court, 
                        name: 'London Probate Department', 
                        areas_of_law: [probate_area], 
                        court_types: [probate_court_type]) }

  let!(:royal_court) { create(:court, 
                        name: 'Royal Courts of Justice', 
                        areas_of_law: [bankruptcy_area], 
                        court_types: [high_court_type]) }


  scenario 'Go to a court page and it should have a link to GOV.UK under related links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk']") 
  end

  scenario 'Go to a court page and it should have a link to FormFinder under related links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='http://hmctsformfinder.justice.gov.uk/HMCTS/FormFinder.do']") 
  end

  scenario 'Go to a court page and it should have a link to fees under related links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='http://www.justice.gov.uk/courts/fees']") 
  end

  scenario 'A Court dealing with Money Claims should have relavent links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/make-court-claim-for-money']") 
  end

  scenario 'A Court dealing with Repossessions (land or property) should have relavent links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/repossession']") 
  end

  scenario 'A Court dealing with Repossessions (defendants and claimants) should have relavent links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/possession-claim-online-recover-property']") 
  end

  scenario 'A Court dealing with Divorce should have relavent links' do
    visit "/courts/barnstaple-crown-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/divorce']") 
  end

  scenario 'A Court dealing with Adoption should have relavent links' do
    visit "/courts/barnstaple-crown-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/child-adoption']") 
  end

  scenario 'A Court dealing with Wills, Probate and Inheritance should have relavent links' do
    visit "/courts/london-probate-department"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/wills-probate-inheritance/applying-for-a-grant-of-representation']")
  end

  scenario 'A Court NOT dealing with Money Claims should NOT have relavent links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/make-court-claim-for-money']") 
  end

  scenario 'A Court NOT dealing with Repossessions (land or property) should NOT have relavent links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/repossession']") 
  end

  scenario 'A Court NOT dealing with Repossessions (defendants and claimants) should NOT have relavent links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/possession-claim-online-recover-property']") 
  end

  scenario 'A Court NOT dealing with Divorce should NOT have relavent links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/divorce']") 
  end

  scenario 'A Court NOT dealing with Adoption should NOT have relavent links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/child-adoption']") 
  end

  scenario 'A Court NOT dealing with Wills, Probate and Inheritance should NOT have relavent links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/wills-probate-inheritance/applying-for-a-grant-of-representation']")
  end

  scenario 'A Court type of County court should have relavent links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='http://www.civilmediation.org/']") 
  end

  scenario 'A Court type of Family Court should have relavent links' do
    visit "/courts/barnstaple-crown-court"
    expect(page).to have_xpath("//*/a[@href='http://www.familymediationcouncil.org.uk/']") 
  end

  scenario 'A Court that is NOT a type of County Court should not have relavent links for it' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='http://www.civilmediation.org/']") 
  end

  scenario 'A Court that is NOT a type of Family court should not have relavent links for it' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='http://www.familymediationcouncil.org.uk/']") 
  end

end