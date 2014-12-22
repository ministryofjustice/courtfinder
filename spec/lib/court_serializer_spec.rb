require 'spec_helper'


describe 'CourtSerializer' do


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

  let(:now) { Time.now }

  it 'should serialize!' do
    # allow(court).to receive(:graph_updated_at).and_return(now)
    Court.any_instance.stub(:graph_updated_at).and_return(now)

    serializer = CourtSerializer.new(court.id)
    serializer.serialize
    expect(serializer.hash).to eq expected_hash
  end


end


def expected_hash
  {
    'name'         => 'My test court',
    'slug'         => 'my-test-court',
    'updated_at'   => now.strftime('%Y-%m-%dT%H:%M:%S.%4NZ'),
    'update_type'  => 'major',
    'locale'       => 'en',
    'closed'       => false,
    'alert'        => 'Danger!  This is a test court',
    'lat'          => '51.499862',
    'lon'          => '-0.135007',
    'court_number' => 1234,
    'DX'           => 'DX 8888888 London',
    'areas_of_law' => [ 'Law Area 1', 'Law Area 2' ],
    'facilities'   => [
        {
          'type'        => 'Disabled access',
          'description' => 'Disabled access and toilet facilities'
        },
        {
          'type'        => 'Guide Dogs',
          'description' => 'Guide dogs are welcome in this court'
        }
      ],
    'parking'      => [
        {
          'type'        => 'offsite',
          'description' => 'An NCP car park is located in Tudor Street, 400 metres from the court building.'
        },
        {
          'type'        => 'blue_badge',
          'description' => 'A limited number of Blue Badge parking bays are situated outside the court.'
        }
      ],
    'opening_times'   => [
        {
          'name'=>'Court counter closed', 
          'description'=>'5.00 pm (4.00 pm Friday)'
        }, 
        {
          'name'=>'Court counter open', 
          'description'=>'9.00 am'
        }, 
        {
          'name'=>'Court Building closed', 
          'description'=>'5.00 pm (4.30 pm Friday)'
        }, 
        {
          'name'=>'Court Building open', 
          'description'=>'9.00 am'
        }
      ],
    'addresses'    => [
        {
          'type'     => 'Postal',
          'town'     => 'London',
          'county'   => 'Greater London',
          'postcode' => 'EC4M 6XX',
          'lines'    => [ 'PO BOX 666']
        },
        {
          'type'     => 'Visiting',
          'town'     => 'London',
          'county'   => 'Greater London',
          'postcode' => 'EC4M 7EH',
          'lines'    => [ 'Old Bailey', 'High Holborn']
        }
      ],
    'contacts' => [
        {
          'name'   => 'Jury Enquiries',
          'number' => '020 7835 3344'
        },
        {
          'name'   => 'Admin',
          'number' => '020 7835 2233'
        },
        {
          'name'   => 'Helpdesk',
          'number' => '020 7835 1122'
        }
      ],
    'emails' => [
        {
          'name'   => '',
          'address' => 'admin@example.com'
        },
        {
          'name'   => 'Jury Enquiries',
          'address' => 'fees@example.com'
        }
      ]  
  }
end

