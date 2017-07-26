require 'spec_helper'

feature 'manage courts address postal' do
  before(:each) do
    court1
    visit '/admin'
    sign_in user
    click_link 'Manage All Courts and Tribunals'
  end
  let(:court1) do
    create(:court, :civil,
      name: "Postal Magistrates' Court",
      slug: "postal_magistrates_court")
  end

  context 'admin' do
    let(:user) { create(:user, admin: true) }

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
        expect(page).to have_text 'Name only alphabetic characters, commas and apostrophes are allowed'
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

    context 'Location codes' do
      scenario 'Update location codes' do
        click_link 'Courts or Tribunals'
        page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click

        expect(find(:xpath, './/input[@id="court_slug"]').value).to eql(court1.slug)
        fill_in 'Crown Court code', with: "3253"
        fill_in 'County Court code', with: "123"
        fill_in 'Magistrates’ Court code', with: "789"

        click_button 'Update'
        expect(page).to have_text("Court was successfully updated.")
        expect(find(:xpath, './/input[@id="court_court_number"]').value).to eql('3253')
        expect(find(:xpath, './/input[@id="court_cci_code"]').value).to eql('123')
        expect(find(:xpath, './/input[@id="court_magistrate_court_location_code"]').value).to eql('789')
      end

      context 'uniquness of codes' do
        before { create(:court, cci_code: 111) }

        scenario 'Validate uniquness of location codes' do
          click_link 'Courts or Tribunals'
          page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click

          expect(find(:xpath, './/input[@id="court_slug"]').value).to eql(court1.slug)
          fill_in 'Crown Court code', with: "3253"
          fill_in 'County Court code', with: "3253"
          fill_in 'Magistrates’ Court code', with: "3253"

          click_button 'Update'
          expect(page).to have_text("Court was successfully updated.")
          expect(find(:xpath, './/input[@id="court_court_number"]').value).to eql('3253')
          expect(find(:xpath, './/input[@id="court_cci_code"]').value).to eql('3253')
          expect(find(:xpath, './/input[@id="court_magistrate_court_location_code"]').value).to eql('3253')

          fill_in 'Crown Court code', with: "111"
          click_button 'Update'
          expect(page).not_to have_text("Court was successfully updated.")
        end
      end
    end
  end

  context 'user' do
    let(:user) { create(:user, admin: false) }

    scenario 'is not abble to edit court name and slug' do
      click_link 'Courts or Tribunals'
      page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click
      within(:xpath, './/div[@id="basic-info"]') do
        expect(page).to have_field('Name', with: court1.name, disabled: true)
        expect(page).to have_field('Slug', with: court1.slug, disabled: true)
      end
    end
  end
end
