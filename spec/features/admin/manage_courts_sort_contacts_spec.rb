require 'spec_helper'

feature 'Sort contact numbers' do
  let!(:contact_types) do
end

  context 'admin' do
    let(:court) { create(:court, name: 'the-court') }
    let!(:user) { create(:user) }
    let(:contact_type_second) {create(:contact_type, name: 'Second')}    
    let(:contact_type_first) {create(:contact_type, name: 'First')}    
    let(:contact_type_dx) {create(:contact_type, name: 'DX')}    
    let(:contact_type_fax) {create(:contact_type, name: 'Fax')}    
    let(:contact_type_enquiries) {create(:contact_type, name: 'Enquiries')}

    let!(:contact_second) {create(:contact, telephone: 1, court_id: court.id, contact_type_id: contact_type_second.id, sort: 1)}    
    let!(:contact_first) {create(:contact, telephone: 2, court_id: court.id, contact_type_id: contact_type_first.id, sort: 2)}    
    let!(:contact_enquiries) {create(:contact, telephone: 3, court_id: court.id, contact_type_id: contact_type_enquiries.id, sort: 3)}    
    let!(:contact_dx) {create(:contact, telephone: 4, court_id: court.id, contact_type_id: contact_type_dx.id, sort: 4)}    
    let!(:contact_fax) {create(:contact, telephone: 5, court_id: court.id, contact_type_id: contact_type_fax.id, sort: 5)}
 
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'sort the number', js: true do
      visit '/admin/courts/the-court/edit'
      expect(page).to have_content('Editing court')
      click_link 'Contact Numbers'
      expect(page).to have_content('reorder phone numbers')
      click_link 'reorder phone numbers'
      expect(page).to have_content('edit contacts')
      
      click_button 'Sort'
      expect(page).to have_content('edit contacts')

      # Order should be Enquries/First/Second/DX/Fax
      # We force Enquires to be first - and place Fax & DX at the end
      uk = find('#contactNumbers').text
      uk.index("Enquiries").should < uk.index("First")
      uk.index("First").should < uk.index("Second")
      uk.index("Second").should < uk.index("Fax")
      uk.index("Fax").should < uk.index("DX")
      
      click_button 'Update'
      expect(page).to have_content('Court was successfully updated')

      #Check sort is saved
      visit '/admin/courts/the-court/edit'
      expect(page).to have_content('Editing court')
      click_link 'Contact Numbers'
      expect(page).to have_content('reorder phone numbers')
      click_link 'reorder phone numbers'
      expect(page).to have_content('edit contacts')

      uk = find('#contactNumbers').text
      uk.index("Enquiries").should < uk.index("First")
      uk.index("First").should < uk.index("Second")
      uk.index("Second").should < uk.index("Fax")
      uk.index("Fax").should < uk.index("DX")

    end
  end
end
