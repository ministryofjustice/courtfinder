require 'spec_helper'
require 'capybara/email/rspec'

feature 'reset password' do
  let(:email_address) { 'user@example.com' }
  let(:old_password) { 'old-password' }
  let(:new_password) { 'new-password' }

  before(:each) do
    User.create! email: email_address, password: old_password, password_confirmation: old_password
    clear_emails
  end

  scenario 'reset a password' do
    visit '/admin'
    click_link 'Forgot your password?'

    expect(page).to have_content 'Forgot your password?'
    fill_in 'Email', with: email_address
    click_button 'Send me reset password instructions'

    open_email(email_address)
    expect(current_email).to have_link 'Change my password'
    current_email.click_link 'Change my password'

    expect(page).to have_content 'Change your password'
    fill_in 'New password', with: new_password
    fill_in 'Confirm your new password', with: new_password
    click_button 'Change my password'

    expect(current_path).to eq '/admin/courts'
    expect(page).to have_content "Signed in as #{email_address}"
  end
end
