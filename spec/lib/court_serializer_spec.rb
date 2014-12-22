require 'spec_helper'
require File.dirname(__FILE__) + '/../mocks/mock_gov_uk_json.rb'

describe 'CourtSerializer' do

  let(:stubbed_time)    { Time.new(2014,12,22,13,58,53.12349) }

  let(:expected_hash)   { MockGovUkJson.expected_hash }

  describe '.serialize' do
    let(:court) do
      court = create(:full_court_details)
      court.addresses << create(:visiting_address)
      court.addresses << create(:postal_address)
      court.contacts.create(telephone: '020 7835 1122', contact_type_id: create(:contact_type).id)
      court.contacts.create(telephone: '020 7835 2233', contact_type_id: create(:contact_type_admin).id)
      court.contacts.create(telephone: '020 7835 3344', contact_type_id: create(:contact_type_jury).id)

      court.emails.create(address: 'fees@example.com', contact_type_id: court.contacts.last.contact_type_id)
      court.emails.create(address: 'admin@example.com')

      court.areas_of_law.create(name: 'Law Area 1')
      court.areas_of_law.create(name: 'Law Area 2')
      court
    end

    

    it 'should serialize!' do
      Court.any_instance.stub(:graph_updated_at).and_return(stubbed_time)

      serializer = CourtSerializer.new(court.id)
      serializer.serialize
      expect(serializer.hash).to eq expected_hash
    end
  end

end


