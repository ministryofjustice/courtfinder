require 'spec_helper'

feature 'Area of law landing pages', skip: 'not needed anymore' do
  let!(:area_of_law) { create(:area_of_law) }

  scenario 'Enter the site using a /search/:area_of_law will take me to a preselected search' do
    visit "/search/#{area_of_law.to_param}"
    expect(page).to have_select('area_of_law', selected: area_of_law.name)
  end

  scenario 'Using an old slug will redirect to the new path' do
    old = "/search/#{area_of_law.to_param}"
    area_of_law.name = 'New Area Of Law'
    area_of_law.save
    
    visit old

    expect(current_path).to eq('/search/new-area-of-law')
  end

  scenario 'Returns the normal page when entering invalid route' do
    visit '/search/i-am-so-invalid'

    expect(page).to have_content('Search for a court')
  end

  scenario 'Should not redirect loop when using the slug a second time around' do
    old_name = area_of_law.name
    area_of_law.name = 'New Area Of Law'
    area_of_law.save
    area_of_law.name = old_name
    area_of_law.save

    visit "/search/#{area_of_law.to_param}"
    expect(page).to have_select('area_of_law', selected: area_of_law.name)
  end


end