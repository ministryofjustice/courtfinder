require 'spec_helper'

feature 'Related links for court pages' do
  let!(:money_claims_area) { create(:area_of_law, name: 'Money claims')}
  let!(:repossessions_area) { create(:area_of_law, name: 'Housing possession')}

  let!(:divorce_area) { create(:area_of_law, name: 'Divorce')}
  let!(:adoption_area) { create(:area_of_law, name: 'Adoption')}
  let!(:probate_area) { create(:area_of_law, name: 'Probate')}
  let!(:bankruptcy_area) { create(:area_of_law, name: 'Bankruptcy')}

  let!(:county_court_type) { CourtType.create!(name: 'County Court') }
  let!(:family_court_type) { CourtType.create!(name: 'Family court') }

  let!(:probate_court_type) { create(:court_type, name: 'Probate court') }
  let!(:high_court_type) { create(:court_type, name: 'High court') }

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

  let!(:create_external_links) do
    ExternalLink.create(text: 'GOV.UK', url: 'https://www.gov.uk', always_visible: true)
    ExternalLink.create(text: 'Forms', url: 'http://hmctsformfinder.justice.gov.uk/HMCTS/FormFinder.do', always_visible: true)
    ExternalLink.create(text: 'Fees', url: 'http://www.justice.gov.uk/courts/fees', always_visible: true)

    CourtType.find_by_name('Family court').external_links.create(text: 'Family Mediation', url: 'http://www.familymediationcouncil.org.uk/', always_visible: false)
    CourtType.find_by_name('County Court').external_links.create(text: 'Civil Mediation', url: 'http://www.civilmediation.org/', always_visible: false)

    AreaOfLaw.find_by_name('Money claims').external_links.create(text: 'Money claims', url: 'https://www.gov.uk/make-court-claim-for-money')

    AreaOfLaw.find_by_name('Housing possession').external_links.create(text: 'Repossessions (land or property)', url: "https://www.gov.uk/repossession")
    AreaOfLaw.find_by_name('Housing possession').external_links.create(text: 'Repossessions', url: "https://www.gov.uk/possession-claim-online-recover-property")

    AreaOfLaw.find_by_name('Divorce').external_links.create(text: 'Divorce', url: "https://www.gov.uk/divorce")
    AreaOfLaw.find_by_name('Adoption').external_links.create(text: 'Child adoption' , url: "https://www.gov.uk/child-adoption")
    AreaOfLaw.find_by_name('Probate').external_links.create(text: 'Wills, probate and inheritance' , url: "https://www.gov.uk/wills-probate-inheritance/applying-for-a-grant-of-representation" )
  end

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

  scenario 'A Court dealing with Money Claims should have relevant links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/make-court-claim-for-money']")
  end

  scenario 'A Court dealing with Repossessions (land or property) should have relevant links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/repossession']")
  end

  scenario 'A Court dealing with Repossessions (defendants and claimants) should have relevant links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/possession-claim-online-recover-property']")
  end

  scenario 'A Court dealing with Divorce should have relevant links' do
    visit "/courts/barnstaple-crown-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/divorce']")
  end

  scenario 'A Court dealing with Adoption should have relevant links' do
    visit "/courts/barnstaple-crown-court"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/child-adoption']")
  end

  scenario 'A Court dealing with Wills, Probate and Inheritance should have relevant links' do
    visit "/courts/london-probate-department"
    expect(page).to have_xpath("//*/a[@href='https://www.gov.uk/wills-probate-inheritance/applying-for-a-grant-of-representation']")
  end

  scenario 'A Court NOT dealing with Money Claims should NOT have relevant links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/make-court-claim-for-money']")
  end

  scenario 'A Court NOT dealing with Repossessions (land or property) should NOT have relevant links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/repossession']")
  end

  scenario 'A Court NOT dealing with Repossessions (defendants and claimants) should NOT have relevant links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/possession-claim-online-recover-property']")
  end

  scenario 'A Court NOT dealing with Divorce should NOT have relevant links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/divorce']")
  end

  scenario 'A Court NOT dealing with Adoption should NOT have relevant links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/child-adoption']")
  end

  scenario 'A Court NOT dealing with Wills, Probate and Inheritance should NOT have relevant links' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='https://www.gov.uk/wills-probate-inheritance/applying-for-a-grant-of-representation']")
  end

  scenario 'A Court type of County court should have relevant links' do
    visit "/courts/liverpool-civil-and-family-court"
    expect(page).to have_xpath("//*/a[@href='http://www.civilmediation.org/']")
  end

  scenario 'A Court type of Family Court should have relevant links' do
    visit "/courts/barnstaple-crown-court"
    expect(page).to have_xpath("//*/a[@href='http://www.familymediationcouncil.org.uk/']")
  end

  scenario 'A Court that is NOT a type of County Court should not have relevant links for it' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='http://www.civilmediation.org/']")
  end

  scenario 'A Court that is NOT a type of Family court should not have relevant links for it' do
    visit "/courts/royal-courts-of-justice"
    expect(page).to have_no_xpath("//*/a[@href='http://www.familymediationcouncil.org.uk/']")
  end

end
