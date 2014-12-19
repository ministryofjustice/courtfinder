# Faker::Config.locale = 'en-gb'

FactoryGirl.define do

  factory :court do
    sequence(:name) { |n| "Court of LAW number #{n}" }
    display true
    areas_of_law { create_list(:area_of_law, 2) }
    latitude 50
    longitude 0

    factory :full_court_details do
      name 'My test court'
      alert 'Danger!  This is a test court'
      latitude 51.499862
      longitude -0.135007
      court_number 1234
      court_facilities { [ create(:disabled_access_court_facility), create(:guide_dogs_court_facility) ]}
      parking_onsite nil
      parking_offsite "An NCP car park is located in Tudor Street, 400 metres from the court building."
      parking_blue_badge "A limited number of Blue Badge parking bays are situated outside the court."
      opening_times { [ create(:court_open_time), create(:court_closed_time), create(:counter_open_time), create(:counter_closed_time)]}
    end
  end

  factory :postcode_court do
    postcode Faker::Address.postcode
    sequence(:court_number)
    sequence(:court_name) {|n| "Court #{n}"}
  end

  factory :court_type do
  end

  factory :country do
    factory :country_england do
      name 'England'
    end
  end


  factory :county do
    factory :county_greater_london do
      name "Greater London"
      association :country, factory: :country_england
    end
  end


  factory :town do
    factory :town_london do
      name 'London'
      association :county, factory: :county_greater_london
    end
  end

  factory :address do
    factory :visiting_address do
      association :address_type, factory: :address_type
      address_line_1 'Old Bailey'
      address_line_2  'High Holborn'
      association :town, factory: :town_london
      postcode 'EC4M 7EH'
      dx 'DX 123456 London'
    end
    factory :postal_address do
      association :address_type, factory: :postal_address_type
      address_line_1 'PO BOX 666'
      association :town, factory: :town_london
      postcode 'EC4M 6XX'
      dx 'DX 8888888 London'
    end
  end

  factory :address_type do
    name 'Visiting'
    factory :postal_address_type do
      name 'Postal'
    end
  end

  factory :area_of_law do
    sequence(:name) {|n| "Law Area #{n}" }
  end

  factory :feedback do
  end

  factory :contact_type do
    name {'Helpdesk'}
    factory :contact_type_admin do
      name 'admin'
    end
    factory :contact_type_jury do
      name 'jury'
    end
  end

  factory :contact do
    factory :helpdesk_contact do
      telephone '020 7835 3344'
      association :contact_type, factory: :contact_type
    end
    factory :admin_contact do
      telephone '020 7835 4455'
      association :contact_type, factory: :contact_type_admin
    end
    factory :jury_contact_type do
      telephone '020 7835 5566'
      association :contact_type, factory: :contact_type_jury
    end
  end

  factory :local_authority do
    sequence(:name) {|i| "Local Authority #{i}"}
  end

  factory :area_of_law_group do
    sequence(:name) {|n| "Group #{n}"}
  end

  factory :user do
    email { Faker::Internet.email }
    password 'password123'
    password_confirmation 'password123'
  end

  factory :court_facility do
    description 'Disabled access and toilet facilities'
    factory :disabled_access_court_facility do
      description 'Disabled access and toilet facilities'
      association :facility, factory:  :disabled_access_facility
    end
    factory :guide_dogs_court_facility do
      description 'Guide dogs are welcome in this court'
      association :facility, factory:  :guide_dogs_facility
    end
  end

  factory :facility do
    name 'Disabled access'
    factory :disabled_access_facility do
      name 'Disabled access'
      image_description 'Wheelchair'
    end
    factory :guide_dogs_facility do
      name 'Guide Dogs'
      image_description 'dog'
    end
  end

  factory :external_link do
    always_visible true
  end

  factory :opening_type do
    factory :building_open do
      name 'Court Building open'
    end
    factory :building_closed do
      name 'Court Building closed'
    end
    factory :counter_open do
      name 'Court counter open'
    end
    factory :counter_closed do
      name 'Court counter closed' 
    end
  end

  factory :opening_time do
    factory :court_open_time do
      name '9.00 am'
      association :opening_type, factory: :building_open
    end
    factory :court_closed_time do
      name '5.00 pm (4.30 pm Friday)'
      association :opening_type, factory: :building_closed
    end
    factory :counter_open_time do
      name '9.00 am'
      association :opening_type, factory: :counter_open
    end
    factory :counter_closed_time do
      name '5.00 pm (4.00 pm Friday)'
      association :opening_type, factory: :counter_open
    end
  end




end
