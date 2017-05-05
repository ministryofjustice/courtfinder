require 'spec_helper'

feature 'Hide Aols' do
  context 'admin' do
    let!(:court) { create(:court, name: 'the court', hide_aols: true) }
    let!(:user) { create(:user) }

    before do
      visit '/admin'
      sign_in user
    end

    scenario 'edit a court and verify the change', js: true do
      visit edit_admin_court_path(court)
      visit '/admin/courts/the-court/edit'
      expect(page).to have_content('Editing court')
      click_link 'Areas of law'

      ctl = find('#court_hide_aols')
      expect(ctl).to be_checked
    end
  end
end
