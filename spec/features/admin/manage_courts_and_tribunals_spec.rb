require 'spec_helper'

feature 'manage courts and tribunals' do
  before(:each) do
    visit '/admin'
    sign_in create(:user)
  end

  let!(:court1) { create(:court, name: "Abergavenny Magistrates' Court") }
  let!(:court2) { create(:court, name: "Grantham Magistrates' Court") }
  let!(:court3) { create(:court, name: "Manchester County Court") }

  scenario 'navigate to court by using an A to Z list', js: true  do
    click_link 'Manage All Courts and Tribunals'
    expect(page).to have_xpath(".//table[@class='areaOfLaw dataTable no-footer']/tbody/tr", count: 3)

    within :xpath, "//ul[@class='tabs-nav clearfix']" do
      click_link 'G'
    end

    expect(page).to have_xpath(".//table[@class='areaOfLaw dataTable no-footer']/tbody/tr", count: 1)
    line = page.find(:xpath, ".//table[@class='areaOfLaw dataTable no-footer']/tbody/tr")
    expect(line.text).to eql("Grantham Magistrates' Court")
  end

  scenario 'find court by using quick search', js: true do
    click_link 'Manage All Courts and Tribunals'
    expect(page).to have_xpath(".//table[@class='areaOfLaw dataTable no-footer']/tbody/tr", count: 3)

    line = page.find(:xpath, ".//input[@type='search']")
    line.set('Manchester')

    line.trigger('keyPress')
    expect(page).to have_xpath(".//table[@class='areaOfLaw dataTable no-footer']/tbody/tr", count: 1)
    line = page.find(:xpath, ".//table[@class='areaOfLaw dataTable no-footer']/tbody/tr")
    expect(line.text).to eql("Manchester County Court")
  end

end
