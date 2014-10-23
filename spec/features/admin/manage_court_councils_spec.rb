require 'spec_helper'

feature 'manage the councils for civil and family courts' do
  before(:each) do
    areas_of_law = %w(Children Divorce Adoption).map { |name| create :area_of_law, name: name }
    @court = create :court, areas_of_law: areas_of_law
    @councils = 3.times.map { create :council }

    visit '/admin'
    sign_in create(:user)
  end

  scenario 'add councils to a court' do
    visit '/admin/courts/family'

    click_link 'Children'
    within :xpath, "//tr[contains(.,'#{@court.name}')]" do
      fill_in 'court[children_councils_list]', with: @councils.map(&:name).join(',')
      click_button 'Save'
    end

    expect(page).to have_content 'Court was successfully updated.'
    within :xpath, "//tr[contains(.,'#{@court.name}')]" do
      expect(find_field('court[children_councils_list]').value).to eq @councils.map(&:name).join(',')
    end
  end
end
