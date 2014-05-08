require 'spec_helper'

feature 'Manage area of law groups' do

  context 'admin' do
    let!(:user) { create(:user) }
    before do
      visit '/admin'
      sign_in user
    end

    scenario 'create a group' do
      visit '/admin/area-of-law-groups'
      click_link 'New Group'
      page.should have_content 'New Group'

      fill_in 'Name', with: 'My Group'
      click_button 'Create Area of law group'
      page.should have_content('Group was successfully created')
      page.should have_content('My Group')
    end

    scenario 'edit a group' do
      group = create(:area_of_law_group, name: 'Existing group')
      visit '/admin/area-of-law-groups'
      page.should have_content('Existing group')
      click_link 'Edit'

      fill_in 'Name', with: 'Updated group'
      click_button 'Update Area of law group'
      page.should have_content('Group was successfully updated')
      page.should have_content('Updated group')
    end

  end

end