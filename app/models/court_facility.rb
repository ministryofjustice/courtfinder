class CourtFacility < ActiveRecord::Base
  belongs_to :court
  belongs_to :facility
  attr_accessible :description, :facility_id, :sort

  default_scope :order => :sort
end
