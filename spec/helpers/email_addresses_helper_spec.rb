require 'spec_helper'

describe EmailAddressesHelper do

  it "return mail_to link" do
    link = helper.format_email_address('test@hmcts.net')
    expect(link).to eql('<a href="mailto:test@hmcts.net">test@hmcts.net</a>')
  end
end
