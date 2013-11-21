FactoryGirl.define do
  factory :court do
    sequence(:name) { |n| "Court of LAW number #{n}" }
    display true
    areas_of_law { FactoryGirl.create_list(:area_of_law, 2) }
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
end
