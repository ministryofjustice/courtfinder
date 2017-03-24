require 'spec_helper'

feature 'Court Contact Explanation' do
  let!(:contact_types) do
    create(:contact_type, name: 'Enquiries')
  end

  context 'admin' do
    let!(:court) { create(:court, name: 'the-court') }
    let!(:user) { create(:user) }
    let(:long_explanation) do
      'Enquiries Explanation which is very very very very very long message and even loooongeeeer'
    end
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
        select 'Enquiries', from: 'Service type'
        fill_in 'Number', with: '01443 408181'
        fill_in 'Explanation', with: 'Enquiries Explanation'
      end

      click_button 'Update'
      expect(page).to have_content('Court was successfully updated')

      visit '/admin/courts/the-court/edit'
      expect(page).to have_content('Editing court')

      click_link 'Contact Numbers'
      expect(page.body).to have_content('01443 408181')
      expect(page.body).to have_content('Enquiries Explanation')
    end

    scenario 'validating explanation message', js: true do
      visit '/admin/courts/the-court/edit'
      expect(page).to have_content('Editing court')
      click_link 'Contact Numbers'
      click_link 'Add contact information'

      within_fieldset('contact-element') do
        select 'Enquiries', from: 'Service type'
        fill_in 'Number', with: '01443 408181'
        fill_in 'Explanation', with: long_explanation
      end

      click_button 'Update'
      expect(page).not_to have_content('Court was successfully updated')
      expect(page).to have_content('Contacts number explanation is too long (contains 90 characters and maximum is 85 characters)')
    end
  end
end
