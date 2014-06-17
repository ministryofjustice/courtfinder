require 'spec_helper'

feature 'Money claims and possession should show helpful messages' do 
  let!(:money_claims_area) { create(:area_of_law, name: 'Money claims', type_money_claims: true)}
  let!(:repossessions_area) { create(:area_of_law, name: 'Housing possession', type_possession: true)}
  let!(:divorce_area) { create(:area_of_law, name: 'Divorce', type_divorce: true)}

  let!(:money_claims_court) { create(:court,
                        name: 'County Court Money Claims Centre (CCMCC)',
                        slug: 'county-court-money-claims-centre-ccmcc',
                        areas_of_law: [money_claims_area]) }

  let!(:barnstaple_court) { create(:court,
                        name: 'Barnstaple Crown Court',
                        areas_of_law: [repossessions_area]) }

  let!(:london_court) { create(:court,
                        name: 'London Probate Department',
                        areas_of_law: [divorce_area]) }


  scenario 'When searched for a money claims court, it should only show the County Court Money Claims Centre (CCMCC) as the only search result' do
    visit '/'
    fill_in 'search-main', with: 'SW1H 9AJ'
    select 'Money claims', from: 'Area of law'
    click_button 'Search'
    page.all('.search-results > li').count.should eql(1)
    expect(page.find('.court-title')).to have_content('County Court Money Claims Centre')
  end

  scenario 'When searched for a money claims court, it should present a helpful text underneath the search result' do
    visit '/'
    fill_in 'search-main', with: 'SW1H 9AJ'
    select 'Money claims', from: 'Area of law'
    click_button 'Search'
    expect(page.find('.search-related-information')).to have_content('It will be cheaper to make a money claim online.')
  end

  scenario 'When searched for a repossession court, from the search page should only show' do
    CourtSearch.any_instance.stub(:results).and_return({courts: [barnstaple_court], found_in_area_of_law: 1 })

    visit '/'
    fill_in 'search-main', with: 'SW1H 9AJ'
    select 'Housing possession', from: 'Area of law'
    click_button 'Search'
    expect(page.find('.search-related-information')).to have_content('You may be able to start a possession claim online.')
  end

  scenario "If the search results don't have a money claim or resposession court, it shouldn't have the helpful text" do
    CourtSearch.any_instance.stub(:results).and_return({courts: [london_court], found_in_area_of_law: 1 })

    visit '/'
    fill_in 'search-main', with: 'SW1H 9AJ'
    select 'Divorce', from: 'Area of law'
    click_button 'Search'
    page.all('.search-related-information').count.should eql(0)
  end
end