FactoryGirl.define do

  factory :court do
    sequence(:name) { |n| "Court of LAW number #{n}" }
    display true
    areas_of_law { create_list(:area_of_law, 2) }
    latitude 50
    longitude 0

  end

  factory :postcode_court do
    postcode Faker::Address.postcode
    sequence(:court_number)
    sequence(:court_name) {|n| "Court #{n}"}
  end

  factory :court_type do
  end

  factory :address do
  end

  factory :town do
  end

  factory :address_type do
    name 'Visiting'
  end

  factory :area_of_law do
    sequence(:name) {|n| 'Law Area' }
  end

  factory :feedback do
  end

  factory :contact_type do
    name {'Helpdesk'}
  end

  factory :contact do
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

    factory :admin do
      admin true
    end

    factory :non_admin do
      admin false
    end
  end

  factory :court_facility do
    description 'Disabled access and toilet facilities'
  end

  factory :facility do
    name 'Disabled access'
    image_description 'Wheelchair'
    image_file File.open("#{ Rails.root }/spec/fixtures/assets/firstaid.png")
  end

  factory :external_link do
    always_visible true
  end

  trait :civil do
    areas_of_law {[create(:area_of_law, name: AreaOfLaw::Name::MONEY_CLAIMS)]}
  end

  factory :emergency_message do
  end

end
