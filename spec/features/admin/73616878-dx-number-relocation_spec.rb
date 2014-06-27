require 'spec_helper'

feature 'DX number' do

  context 'admin' do
    let!(:user) { create(:user) }
    let!(:court) { create(:court, name: 'the-court') }
    let!(:contact_type) { create(:contact_type, name: 'DX') }

    before do
      visit '/admin'
      sign_in user
    end

    scenario 'edit a court and verify the change', js: true do

      visit '/admin/courts/the-court/edit'
      page.should have_content('Editing court')
      click_link 'Contact Numbers'
      click_link 'Add contact information'

      within_fieldset('contact-element') do
        select 'DX', from: 'Service type'
        fill_in 'Number', with: 'DX 160040 Strand 4'
      end

      click_button 'Update'
      page.should have_content('Court was successfully updated')

      visit '/courts/the-court'
      page.should have_content('DX 160040 Strand 4')
    end

  end

end
