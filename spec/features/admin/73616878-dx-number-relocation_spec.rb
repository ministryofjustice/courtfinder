require 'spec_helper'

feature 'DX number' do

  context 'admin' do
    let!(:user) { create(:user) }
    let!(:court) { create(:court) }
    let!(:contact_type) { create(:contact_type, name: 'DX') }

    before do
      visit '/admin'
      sign_in user
    end

    scenario 'edit a court', js: true do
      visit '/admin/courts/court-of-law-number-1/edit'
      page.should have_content('Editing court')
      click_link 'Phone'
      click_link 'Add phone'

      within_fieldset('contact-element') do
        select 'DX', from: 'Service type'
        fill_in 'Number', with: 'DX 160040 Strand 4'
      end

      click_button 'Update'
      save_and_open_page

      page.should have_content('Court was successfully updated')
    end

  end

end
