# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :postcode_court do
    postcode "MyString"
    court_number 1
    court_name "MyString"
    court nil
  end
end