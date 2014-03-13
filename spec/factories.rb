FactoryGirl.define do
  factory :court do
    sequence(:name) { |n| "Court of LAW number #{n}" }
    display true
    areas_of_law { create_list(:area_of_law, 2) }
    latitude 50
    longitude 0
  end

  factory :court_type do
  end

  factory :address do
  end

  factory :town do
  end

  factory :address_type do
  end

  factory :area_of_law do
    name { 'Posessions' }
  end

  factory :feedback do
  end

  factory :contact_type do
    name {'Helpdesk'}
  end

  factory :contact do
  end

  factory :council do
    sequence(:name) {|i| "Council #{i}"}
  end
end
