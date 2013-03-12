class CourtsAreasOfLaw < ActiveRecord::Base
  belongs_to :court
  belongs_to :area_of_law
  attr_accessible :court_id, :area_of_law_id
end
