class AreaOfLaw < ActiveRecord::Base
  attr_accessible :name, :old_id
  has_many :courts_areas_of_law
  has_many :courts, :through => :courts_areas_of_law
end
