require 'spec_helper'

feature 'edit parking information for courts' do
  before(:each) do
    @court = create :court, name: 'The Court of Public Opinion'

    visit '/admin'
    sign_in create(:user)
  end

  scenario 'see the correct parking options on the court admin interface' do
    visit '/admin/courts/the-court-of-public-opinion/edit'

    click_link 'Parking'
    within '#parking' do
      expect(page).to have_text 'On site parking, located at the venue'
      expect(page).to have_text 'Off site parking, within 500m of the venue'
      expect(page).to have_text 'Blue badge parking for disabled and mobility impaired people'

      within :xpath, "//li[contains(.,'On site parking')]" do
        expect(page).to have_field 'Free on site parking'
        expect(page).to have_field 'Paid on site parking'
        expect(page).to have_field 'No on site parking'
        expect(page).to have_field 'No information available'
      end

      within :xpath, "//li[contains(.,'Off site parking')]" do
        expect(page).to have_field 'Free off site parking'
        expect(page).to have_field 'Paid off site parking'
        expect(page).to have_field 'No off site parking'
        expect(page).to have_field 'No information available'
      end

      within :xpath, "//li[contains(.,'Blue badge parking')]" do
        expect(page).to have_field 'On site blue badge parking'
        expect(page).to have_field 'Limited on site blue badge parking, please contact venue'
        expect(page).to have_field 'No on site blue badge parking'
        expect(page).to have_field 'No information available'
      end
    end
  end

  scenario 'edit parking information for a court' do
    visit '/admin/courts/the-court-of-public-opinion/edit'

    click_link 'Parking'
    within '#parking' do
      within :xpath, "//li[contains(.,'On site parking')]" do
        choose 'Paid on site parking'
      end

      within :xpath, "//li[contains(.,'Blue badge parking')]" do
        choose 'No on site blue badge parking'
      end
    end

    click_button 'Update'
    expect(page).to have_text 'Court was successfully updated'

    click_link 'Parking'
    within '#parking' do
      within :xpath, "//li[contains(.,'On site parking')]" do
        expect(page).to have_checked_field 'Paid on site parking'
      end

      within :xpath, "//li[contains(.,'Off site parking')]" do
        expect(page).to have_checked_field 'No information available'
      end

      within :xpath, "//li[contains(.,'Blue badge parking')]" do
        expect(page).to have_checked_field 'No on site blue badge parking'
      end
    end
  end
end
