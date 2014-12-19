include FactoryGirl::Syntax::Methods

court = create(:full_court_details)
court.addresses << create(:visiting_address)
court.addresses << create(:postal_address)
court.contacts.create(telephone: '020 7835 1122', contact_type_id: create(:contact_type).id)
court.contacts.create(telephone: '020 7835 2233', contact_type_id: create(:contact_type_admin).id)
court.contacts.create(telephone: '020 7835 3344', contact_type_id: create(:contact_type_jury).id)

court.emails.create(address: 'fees@example.com', contact_type_id: court.contacts.last.contact_type_id)
court.emails.create(address: 'admin@example.com')