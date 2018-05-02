require 'spec_helper'

feature 'manage courts address postal' do
  before(:each) do
    visit '/admin'
    sign_in user
    click_link 'Manage All Courts and Tribunals'
  end
  let(:user) { create(:user) }
  let(:town1) { build(:town, name: 'town 1') }

  # Address type Postal
  let(:address_type_postal) { create(:address_type, name: "Postal") }
  let(:court1) do
    build(:court, :civil,
      name: "Postal Magistrates' Court",
      slug: "postal_magistrates_court")
  end

  let(:address_court1) do
    create(:address, court: court1,
                     address_type_id: address_type_postal["id"],
                     postcode: 'M60 9DJ', address_line_1: "AD1", town: town1)
  end

  let(:address_area) { create :area }

  scenario 'Check postal lat  & lng' do
    court1.addresses << address_court1
    court1.save
    click_link 'Courts or Tribunals'
    page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court1.slug)}']").click
    click_link("Addresses")
    expect(page).to_not have_content("Latitude:")
    expect(page).to_not have_content("Longitude:")
  end

  context 'new court' do
    before do
      address_type_postal
      address_area
      user.update(admin: true)
      town1.save
    end

    scenario 'create new address for new court', js: true do
      click_link 'Courts or Tribunals'
      expect(page).to have_text('Listing courts and tribunals')
      click_link('New court or tribunal')
      fill_in('Name', with: 'Court one two three')
      select(address_area.name, from: 'Area')

      click_link('Addresses')
      within(:xpath, ".//div[@id='group-addresses']") do
        click_link('Add address')
        select('Postal', from: 'Address type')
        fill_in('Address line 1', with: '102 Petty France')
        select(town1.name, from: 'Town')
      end
      click_button('Update')
      expect(page).to have_text('Court was successfully created')
      last_court = Court.last
      expect(last_court.name).to eql('Court one two three')
      expect(last_court.addresses.last.is_primary?).to be_truthy
    end
  end
end
