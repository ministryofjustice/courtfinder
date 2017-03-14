require 'spec_helper'

feature 'manage courts address postal' do
  before(:each) do
    visit '/admin'
    sign_in create(:user)
    click_link 'Manage All Courts and Tribunals'
  end
  let!(:town1){ Town.new(name:'town 1') }

  # Address type Postal 
  let(:address_type_postal) {create(:address_type, name: "Postal")}
  let(:court1) { build(:court, :civil, 
    name: "Postal Magistrates' Court",
    slug: "postal_magistrates_court") }
  
  let(:address_court1) { create(:address, court: court1, 
      address_type_id: address_type_postal["id"],
      postcode: 'M60 9DJ', address_line_1: "AD1", town: town1) }
  
  scenario 'Check postal lat  & lng' do
    court1.addresses << address_court1
    court1.save
    click_link 'Courts or Tribunals'
    page.find(:xpath,".//a[@href='#{edit_admin_court_path(court1.slug)}']").click
    click_link("Addresses")
    expect(page).to_not have_content("Latitude:")
    expect(page).to_not have_content("Longitude:")
  end

end
