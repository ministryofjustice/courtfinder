require 'spec_helper'

feature 'DX number' do
  let!(:contact_types) do
    create(:contact_type, name: 'DX')
    create(:contact_type, name: 'telephone')
  end

  context 'admin' do
    let!(:court) { create(:court, name: 'the-court') }
    let!(:user) { create(:user) }

    before do
      visit '/admin'
      sign_in user
    end

    scenario 'edit a court and verify the change', js: true do

      visit '/admin/courts/the-court/edit'
      expect(page).to have_content('Editing court')
      click_link 'Contact Numbers'
      click_link 'Add contact information'

      within_fieldset('contact-element') do
        select 'DX', from: 'Service type'
        fill_in 'Number', with: 'DX 160040 Strand 4'
      end

      click_button 'Update'
      expect(page).to have_content('Court was successfully updated')

      visit '/courts/the-court'
      page.should have_content('DX 160040 Strand 4')
    end

  end

  context 'legal professional user' do
    let!(:court) do
      create(:court, name: 'the-court') do |court|
        court.contacts << create(:contact, telephone: '2343', contact_type_id: ContactType.find_by_name('DX').id, court_id: court.id)
        court.contacts << create(:contact, telephone: '01 1234 56678', contact_type_id: ContactType.find_by_name('telephone').id, court_id: court.id)
      end
    end

    scenario 'see the DX number in the \'Legal professionals section\'' do
      visit '/courts/the-court'
      page.should have_content('Legal professionals')
      within(:css, "div.for-legal-professionals") do
        expect(page).to have_content('DX: 2343')
        expect(page).not_to have_content('01 1234 56678')
      end
    end
  end
end
