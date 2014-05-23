require 'spec_helper'

feature 'Search for court from home page' do
  let!(:area_of_law) { create(:area_of_law, name: 'Divorce', type_divorce: true)}
  let!(:court) { create(:court) }

  before do
    CourtSearch.any_instance.stub(:results).and_return({courts: [court], found_in_area_of_law: 1 })
  end

  scenario 'Auto complete should show when entering a search for a court', js: true do
    visit '/'
    fill_in 'search-main', with: court.name[0]
    page.execute_script "$('#search-main').trigger('compositionupdate')"
    expect(page).to have_content(court.name)
  end

  scenario 'Postcode search wiithout selecting area of law should prompt user to select' do
    visit '/'
    fill_in 'search-main', with: 'SW11 4BG'
    click_button 'Search'

    expect(page).to have_content('You must select an area of law')
  end

  scenario 'User should not be prompted to select area of law for court search' do
    visit '/'
    fill_in 'search-main', with: 'A name'
    click_button 'Search'

    expect(page).not_to have_content('You must select an area of law')
  end

  scenario 'Postcode and area of law should be visible in query string' do
    visit '/'
    fill_in 'search-main', with: 'SW11 4BG'
    select 'Divorce', from: 'Area of law'
    
    click_button 'Search'

    expect(current_url).to include('q=SW11+4BG')
    expect(current_url).to include('area_of_law=Divorce')
  end

  scenario 'Postcode should be displayed in query string as from=<postcode> in court link' do

    visit '/search/?q=SW11+4BG&area_of_law=Divorce'
    expect(page).to have_content(court.name)

    click_link(court.name)

    expect(current_url).to include("from=SW11+4BG")
  end

  scenario 'Area of law prompt should disappear when selecting', js: true do
    visit '/'
    fill_in 'search-main', with: 'SW11 4BG'
    click_button 'Search'

    expect(page).to have_content('You must select an area of law')

    select 'Divorce', from: 'Area of law'

    expect(page).not_to have_content('You must select an area of law')
  end

end
