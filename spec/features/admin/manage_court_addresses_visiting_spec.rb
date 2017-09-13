require 'spec_helper'

feature 'manage courts addresses' do
  before(:each) do
    CourtSearch.any_instance.stub(:latlng_from_postcode).and_return([51.37831, -0.10178])
    visit '/admin'
    sign_in create(:user)
    click_link 'Manage All Courts and Tribunals'
  end
  let!(:town1) { Town.new(name: 'town 1') }

  # Address type Visiting
  let!(:address_type_visiting) { create(:address_type, name: "Visiting") }
  let(:court2) do
    build(:court, :civil,
      name: "Visiting Magistrates' Court",
      slug: "visiting_magistrates_court")
  end

  let!(:address_court2) do
    create(:address, court: court2,
                     address_type_id: address_type_visiting["id"],
                     postcode: 'M60 9DJ', address_line_1: "AD1", town: town1)
  end

  # Address type Postal and visiting
  let!(:address_type_postal_and_visiting) { create(:address_type, name: "Postal and visiting") }
  let(:court3) do
    build(:court, :civil,
      name: "Postal and Visiting Magistrates' Court",
      slug: "postal_and_visiting_magistrates_court")
  end

  let!(:address_court3) do
    create(:address, court: court3,
                     address_type_id: address_type_postal_and_visiting["id"],
                     postcode: 'M60 9DJ', address_line_1: "AD1", town: town1)
  end

  scenario 'Check visiting lat & lng' do
    court2.addresses << address_court2
    court2.save
    click_link 'Courts or Tribunals'
    page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court2.slug)}']").click
    click_link("Addresses")
    expect(page).to have_content("Latitude:")
    expect(page).to have_content("Longitude:")
  end

  scenario 'Check postal and visiting lat & lng' do
    court3.addresses << address_court3
    court3.save
    click_link 'Courts or Tribunals'
    page.find(:xpath, ".//a[@href='#{edit_admin_court_path(court3.slug)}']").click
    click_link("Addresses")
    expect(page).to have_content("Latitude:")
    expect(page).to have_content("Longitude:")
  end

end
