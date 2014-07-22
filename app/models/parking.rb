class Parking < ActiveRecord::Base
  attr_accessible :location_and_cost, :paid
  has_and_belongs_to_many :courts

  #INSIDE = :inside
  #OUTSIDE = :outside

  #validates_inclusion_of :parking_type, in: [INSIDE, OUTSIDE]
  #validates_presence_of :paid
end
