class Parking < ActiveRecord::Base
  attr_accessible :parking_type, :paid
  belongs_to :court

  #INSIDE = :inside
  #OUTSIDE = :outside

  #validates_inclusion_of :parking_type, in: [INSIDE, OUTSIDE]
  #validates_presence_of :paid
end
