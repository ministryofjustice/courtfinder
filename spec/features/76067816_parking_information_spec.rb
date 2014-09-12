require 'spec_helper'

feature 'Adding simple parking information to a court' do
  context 'admin' do
    let!(:court) { create(:court, name: 'the-court') }
    let!(:user) { create(:user) }

    before do
      visit '/admin'
      sign_in user

      visit '/admin/courts/the-court/edit'
      expect(page.status_code).to eq(200)
      expect(page).to have_content('Editing court')
      click_link 'Parking'
    end

    scenario 'A court that has free inside and outsite parking', js: true do
      choose 'court_parking_onsite_parking_onsite_free'
      choose 'court_parking_offsite_parking_offsite_free'

      click_button 'Update'
      expect(page).to have_content('Court was successfully updated')

      visit '/courts/the-court'
      expect(page).to have_content('Free parking is available within a 5 minute walk.')
      expect(page).to have_content('Free, on site parking is available, provided by the court.')
    end

    scenario 'A court that has paid inside parking and outsite parking', js: true do
      choose 'court_parking_onsite_parking_onsite_paid'
      choose 'court_parking_offsite_parking_offsite_paid'

      click_button 'Update'
      expect(page).to have_content('Court was successfully updated')

      visit '/courts/the-court'
      expect(page).to have_content('Paid, on site parking is available, provided by the court')
      expect(page).to have_content('Paid parking is available within a 5 minute walk')
    end
  end
end
