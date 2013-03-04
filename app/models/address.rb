class Address < ActiveRecord::Base
  belongs_to :town
  belongs_to :address_type
  belongs_to :court
  attr_accessible :address1, :address2, :address3, :address4, :dx, :name, :postcode, :town_id, :address_type_id
end
