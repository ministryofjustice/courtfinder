require 'spec_helper'

feature 'manage courts postcodes' do
  before(:each) do
    visit '/admin'
    sign_in create(:user)
    click_link 'Manage All Courts and Tribunals'
  end

  let(:court1) { create(:court, :civil, name: "Abergavenny Magistrates' Court") }
  let(:court2) { create(:court, :civil, name: "Grantham Magistrates' Court") }
  let(:court3) { create(:court, :civil, name: "Manchester County Court") }
  let!(:postcode_court1) { create(:postcode_court, court: court1, postcode: 'A54329') }
  let!(:postcode_court2) { create(:postcode_court, court: court2, postcode: '54330') }
  let!(:postcode_court3) { create(:postcode_court, court: court3, postcode: '54331') }

  scenario 'Moving postcodes', js: true  do
    click_link "Civil courts"
    page.find(:xpath,".//a[@href='#{edit_admin_postcode_path(court1.id)}']").click
    expect(page).to have_text("Move Postcodes from Abergavenny Magistrates' Court")
    page.find(:xpath,".//select[@id='move_to_court']").find(:xpath,"option[@value=#{court2.id}]").select_option

    click_button("Move")
    expect(page).to have_text("No postcodes selected.")
    checkbox = page.find(:xpath,".//div[@id='postcode_selection']//input[@type='checkbox']")
    expect(checkbox.value.to_i).to eql(court1.postcode_courts.last.id)
    checkbox.click

    click_button("Move")
    expect(page).to have_text("1 postcode(s) moved successfully.")
    expect(court2.reload.postcode_courts).to include(postcode_court1, postcode_court2)
    expect(court1.reload.postcode_courts).to eq([])
  end

  scenario 'Adding postcodes to court', js: true  do
    click_link "Civil courts"

    field = find(:xpath,".//form[@id='edit_court_#{court1.id}']//input[@data-default='Add Postcode']")
    field.trigger('click')
    field.set('N103QS')
    page.find(:xpath, ".//div[@id='court_postcode_list_tagsinput']").click

    within(:xpath,".//form[@id='edit_court_#{court1.id}']") do
      click_button("Save")
    end
    expect(page).to have_text('Court was successfully updated.')
    expect(court1.reload.postcode_courts.count).to eql(2)
    expect(court1.postcode_courts.last.postcode).to eql('N103QS')
  end
end
