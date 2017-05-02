require 'spec_helper'

feature 'manage courts address postal' do
  before(:each) do
    court1
    visit '/admin'
    sign_in create(:user, admin: true)
    click_link 'Manage All Courts and Tribunals'
  end
  let(:court1) do
    create(:court, :civil,
      name: "Postal Magistrates' Court",
      slug: "postal_magistrates_court")
  end

  context 'slug' do
    scenario 'Change the name and empty slug' do
      click_link 'Courts or Tribunals'
      page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click

      expect(find(:xpath, './/input[@id="court_slug"]').value).to eql(court1.slug)
      fill_in 'Name', with: "Postal Magistrates' Court test"
      fill_in 'Slug', with: nil
      click_button 'Update'
      expect(find(:xpath, './/input[@id="court_slug"]').value).to eql('postal-magistrates-court-test')
    end

    scenario 'Change the name only' do
      click_link 'Courts or Tribunals'
      page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click

      expect(find(:xpath, './/input[@id="court_slug"]').value).to eql(court1.slug)
      fill_in 'Name', with: "Postal Magistrates' Court test"
      click_button 'Update'
      expect(find(:xpath, './/input[@id="court_slug"]').value).to eql('postal-magistrates-court-test')
    end

    scenario 'Enter court name with invalid character for slug' do
      click_link 'Courts or Tribunals'
      page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click

      expect(find(:xpath, './/input[@id="court_slug"]').value).to eql(court1.slug)
      fill_in 'Name', with: "Court tribunal1"
      click_button 'Update'
      expect(page).to have_text 'Slug only alphabetic characters and hyphens are allowed'
      expect(page).to have_text 'Name only alphabetic characters and apostrophes are allowed'
    end

    scenario 'Enter invalid character for slug' do
      click_link 'Courts or Tribunals'
      page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click

      expect(find(:xpath, './/input[@id="court_slug"]').value).to eql(court1.slug)
      fill_in 'Slug', with: "court-tribunal1"
      click_button 'Update'
      expect(page).to have_text 'Slug only alphabetic characters and hyphens are allowed'
    end

    scenario 'Welsh characters are transliterate to english' do
      click_link 'Courts or Tribunals'
      page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click

      expect(find(:xpath, './/input[@id="court_slug"]').value).to eql(court1.slug)
      fill_in 'Slug', with: "Êcourt-tribunal"
      click_button 'Update'
      expect(page).not_to have_text 'Slug only alphabetic characters and hyphens are allowed'
      expect(find(:xpath, './/input[@id="court_slug"]').value).to eql('ecourt-tribunal')
    end
  end
end
