require 'spec_helper'

describe Contact, type: :model do
  let(:contact) { build(:contact, telephone: '0800 111 222', court_id: court.id) }
  let(:court) { create(:court) }

  it "expect validation message for explanation length error" do
    text = ''
    86.times { text += "s" }
    contact.explanation = text
    expect(contact.save).to be_falsey
    expect(contact.errors.messages).to eql(explanation: ['is too long (maximum is 85 characters)'])
  end
end
