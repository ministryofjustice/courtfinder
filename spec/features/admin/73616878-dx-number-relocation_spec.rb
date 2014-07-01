require 'spec_helper'

feature 'DX number' do
  let!(:contact_type) { create(:contact_type, name: 'DX') }

  context 'admin' do
    let!(:court) { create(:court, name: 'the-court') }
    let!(:user) { create(:user) }

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

  context 'legal professional user' do
    let!(:court) do
      contact_type_dx_id = ContactType.find_by_name('DX').id
      create(:court,
             name: 'the-court',
             contacts: [FactoryGirl.create(:contact, telephone: '2343', contact_type_id: contact_type_dx_id)])
    end

    scenario 'see the DX number in the \'For legal professionals section\'' do
      visit '/courts/the-court'
      save_and_open_page
      page.should have_content('For legal professionals')
      within(:css, "div#for-legal-professionals") do
        page.should have_content('DX: 2343')
      end
    end
  end
end
