class CourtCouncilLink < ActiveRecord::Base
  attr_accessible :name, :court_id, :council_id, :area_of_law_id
  belongs_to :court
  belongs_to :council
  belongs_to :area_of_law
end
