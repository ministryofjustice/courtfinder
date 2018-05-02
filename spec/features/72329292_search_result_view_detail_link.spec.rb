require 'spec_helper'

feature 'Add View details link to each of the search results' do

  let!(:aol_all_law) { create(:area_of_law, name: 'All') }
  let!(:court) { create(:court) }

  before do
    CourtSearch.any_instance.stub(:results).and_return(courts: [court], found_in_area_of_law: 1)
  end

  scenario 'Court search with "All law" area of law should render page with "View details" links' do
    visit '/'
    fill_in 'search-main', with: 'SW1H 9AJ'
    select 'All', from: 'Area of law'
    click_button 'Search'
    expect(page.find('.details-link')).to have_content('View details')
  end
end
