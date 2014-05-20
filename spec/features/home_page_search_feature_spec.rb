require 'spec_helper'

feature 'Search for court from home page', js: true do
  let!(:court) { create(:court) }

  scenario 'Search using court' do
    pending
    visit '/'
    fill_in 'search-main', with: court.name[0]
    page.execute_script "$('#search-main').trigger('keydown')"
    page.should have_content(court.name)
  end

  scenario 'Search wiithout selecting area of law' do
    visit '/'
    fill_in 'search-main', with: 'SW11 4BG'
    click_button 'Search'

    page.should have_content('You must select an area of law')
  end

end
