class Address < ActiveRecord::Base
  belongs_to :town
  belongs_to :address_type
  belongs_to :court
  attr_accessible :address_line_1, :address_line_2, :address_line_3, :address_line_4, :dx, :name, :postcode, :town_id, :address_type_id
end
