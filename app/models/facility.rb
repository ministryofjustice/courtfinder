class Facility < ActiveRecord::Base
  belongs_to :court
  belongs_to :facility_type
  attr_accessible :description, :facility_type_id
end
