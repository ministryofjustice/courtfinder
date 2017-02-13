require 'spec_helper'

feature 'Sort contact numbers' do
  let!(:contact_types) do
    create(:contact_type, name: 'First')
    create(:contact_type, name: 'Second')
    create(:contact_type, name: 'DX')
    create(:contact_type, name: 'Enquiries')
    create(:contact_type, name: 'Fax')
  end

  context 'admin' do
    let!(:court) { create(:court, name: 'the-court') }
    let!(:user) { create(:user) }

    before do
      visit '/admin'
      sign_in user
    end

    scenario 'add Second contacts to a court', js: true do
      byebug
      visit '/admin/courts/the-court/edit'
      expect(page).to have_content('Editing court')

      click_link 'Contact Numbers'
      expect(page).to have_content('Contact numbers')
     
      click_link 'Add contact information'
      expect(page).to have_content('Contact numbers')
      
      within_fieldset('contact-element') do
        select 'Second', from: 'Service type'
        fill_in 'Number', with: '2'
      end

      click_button 'Update'
      expect(page).to have_content('Court was successfully updated')

      visit '/courts/the-court'
      page.should have_content('2')
    end

   #  scenario 'add First contacts to a court', js: true do

   #    visit '/admin/courts/the-court/edit'
   #    expect(page).to have_content('Editing court')
   #    click_link 'Contact Numbers'
   #    click_link 'Add contact information'

   #    within_fieldset('contact-element') do
   #      select 'First', from: 'Service type'
   #      fill_in 'Number', with: '1'
   #    end

   #    click_button 'Update'
   #    expect(page).to have_content('Court was successfully updated')

   #    visit '/courts/the-court'
   #    page.should have_content('1')
   #  end

   #  scenario 'add DX contacts to a court', js: true do

   #    visit '/admin/courts/the-court/edit'
   #    expect(page).to have_content('Editing court')
   #    click_link 'Contact Numbers'
   #    click_link 'Add contact information'

   #    within_fieldset('contact-element') do
   #      select 'DX', from: 'Service type'
   #      fill_in 'Number', with: '160040'
   #    end

   #    click_button 'Update'
   #    expect(page).to have_content('Court was successfully updated')

   #    visit '/courts/the-court'
   #    page.should have_content('160040')
   #  end

   # scenario 'add Enquiries contacts to a court', js: true do

   #    visit '/admin/courts/the-court/edit'
   #    expect(page).to have_content('Editing court')
   #    click_link 'Contact Numbers'
   #    click_link 'Add contact information'

   #    within_fieldset('contact-element') do
   #      select 'Enquiries', from: 'Service type'
   #      fill_in 'Number', with: '160041'
   #    end

   #    click_button 'Update'
   #    expect(page).to have_content('Court was successfully updated')

   #    visit '/courts/the-court'
   #    page.should have_content('160041')
   #  end

   # scenario 'add Fax contacts to a court', js: true do

   #    visit '/admin/courts/the-court/edit'
   #    expect(page).to have_content('Editing court')
   #    click_link 'Contact Numbers'
   #    click_link 'Add contact information'

   #    within_fieldset('contact-element') do
   #      select 'Fax', from: 'Service type'
   #      fill_in 'Number', with: '160042'
   #    end

   #    click_button 'Update'
   #    expect(page).to have_content('Court was successfully updated')

   #    visit '/courts/the-court'
   #    page.should have_content('160042')
   #  end

   #  scenario 'sort the number', js: true do
   #    visit '/admin/courts/the-court/edit'
   #    click_link 'Contact Numbers'
   #    click_link 'reorder phone numbers'

   #    byebug
   #    page.body.index("Second")
   #    page.body.index("First")
   #    page.body.index("DX")
   #    page.body.index("Enquiries")
   #    page.body.index("Fax")

   #    click_button 'Sort'

   #    page.body.index("Enquiries")
   #    page.body.index("First")
   #    page.body.index("Second")
   #    page.body.index("Fax")
   #    page.body.index("DX")


   #    # Order should be Enquries/First/Second/DX/Fax
   #    # We force Enquires to be first - and place Fax & DX at the end
   #    page.body.index("Enquiries").should < page.body.index("First")
   #    page.body.index("Second").should < page.body.index("Fax")
   #    page.body.index("Fax").should < page.body.index("DX")
      
   #    click_button 'Update'
   #    expect(page).to have_content('Court was successfully updated')
   #  end

   #  scenario 'check number are sorted after save', js: true do
   #    visit '/admin/courts/the-court/edit'
   #    expect(page).to have_content('Editing court')
   #    click_link 'Contact Numbers'
   #    expect(page).to have_content('reorder phone numbers')

   #    page.body.index("Enquiries").should < page.body.index("First")
   #    page.body.index("Second").should < page.body.index("Fax")
   #    page.body.index("Fax").should < page.body.index("DX")

   #  end
  end
end
