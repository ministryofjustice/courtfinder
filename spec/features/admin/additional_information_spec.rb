require 'spec_helper'

feature 'Additional information tab/link' do
  before :each do
    visit '/admin'
  end
  let(:court) { create(:court) }
  let(:user) { create(:non_admin) }
  let(:admin) { create(:admin) }

  context 'user' do
    before { sign_in user }

    scenario 'can not see additional information link' do
      visit edit_admin_court_path(court)
      expect(page).not_to have_content('Additional Information')
      expect(page).not_to have_xpath('.//div[@id="further-info"]')
    end
  end

  context 'admin' do
    before { sign_in admin }

    scenario 'can see additional information' do
      visit edit_admin_court_path(court)
      expect(page).to have_content('Additional Information')
      expect(page).to have_xpath('.//div[@id="further-info"]')
    end
  end
end
