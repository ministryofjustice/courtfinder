class Parking < ActiveRecord::Base
  belongs_to :court

  INSIDE = :inside
  OUTSIDE = :outside

  validates_inclusion_of :parking_type, in: [INSIDE, OUTSIDE]
  validates_presence_of :paid
end
