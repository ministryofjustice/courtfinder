require 'spec_helper'

feature 'User permissions for non Admins' do
  before :each do
    visit '/admin'
    sign_in user
  end
  let(:user) { create(:non_admin) }

  context 'pages allowed to access' do
    scenario 'Non-admin users can access Courts or Tribunals page' do
      visit admin_courts_path
      expect(current_path).to eql(admin_courts_path)
    end

    scenario 'Non-admin users can access Manage All Courts and Tribunals page' do
      visit areas_of_law_admin_courts_path
      expect(current_path).to eql(areas_of_law_admin_courts_path)
    end
  end

  context 'pages not allowed to access' do
    scenario 'Non-admin users can not access Address types page' do
      visit admin_address_types_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Towns page' do
      visit admin_towns_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Counties page' do
      visit admin_counties_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Countries page' do
      visit admin_countries_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Emergency Messages page' do
      visit edit_admin_emergency_message_path(1)
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Local Authorities page' do
      visit admin_local_authorities_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Court Types page' do
      visit admin_court_types_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Areas of Law page' do
      visit admin_areas_of_law_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Area of Law Group page' do
      visit admin_area_of_law_groups_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Opening Types page' do
      visit admin_opening_types_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Contact Types page' do
      visit admin_contact_types_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Facilities page' do
      visit admin_facilities_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Regions page' do
      visit admin_regions_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Areas page' do
      visit admin_areas_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Users page' do
      visit admin_users_path
      expect(current_path).to eq(admin_courts_path)
    end

    scenario 'Non-admin users can not access Audit trail page' do
      visit audit_admin_courts_path
      expect(current_path).to eq(admin_courts_path)
    end
  end
end
