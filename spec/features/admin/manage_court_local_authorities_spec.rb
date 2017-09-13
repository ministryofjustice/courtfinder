require 'spec_helper'

feature 'manage the local authorities for civil and family courts' do
  before(:each) do
    areas_of_law = ['Children', 'Divorce', 'Adoption'].map { |name| create :area_of_law, name: name }
    @court = create :court, areas_of_law: areas_of_law
    @local_authorities = Array.new(3) { create :local_authority }

    visit '/admin'
    sign_in create(:user)
  end

  scenario 'add local authorities to a court' do
    visit '/admin/courts/family'

    click_link 'Children'
    within :xpath, "//tr[contains(.,'#{@court.name}')]" do
      fill_in 'court[children_local_authorities_list]', with: @local_authorities.map(&:name).join(',')
      click_button 'Save'
    end

    expect(page).to have_content 'Court was successfully updated.'
    within :xpath, "//tr[contains(.,'#{@court.name}')]" do
      expect(find_field('court[children_local_authorities_list]').value).to eq @local_authorities.map(&:name).join(',')
    end
  end

  scenario 'mark a court as single point of entry' do
    visit '/admin/courts/family'

    click_link 'Children'
    within :xpath, "//tr[contains(.,'#{@court.name}')]" do
      check 'Single point of entry'
      click_button 'Save'
    end

    expect(page).to have_content 'Court was successfully updated.'
    within :xpath, "//tr[contains(.,'#{@court.name}')]" do
      expect(page).to have_checked_field 'Single point of entry'
    end

    click_link 'Divorce'
    within :xpath, "//tr[contains(.,'#{@court.name}')]" do
      expect(page).to have_unchecked_field 'Single point of entry'
    end

    click_link 'Children'
    within :xpath, "//tr[contains(.,'#{@court.name}')]" do
      expect(page).to have_checked_field 'Single point of entry'
    end
  end
end
