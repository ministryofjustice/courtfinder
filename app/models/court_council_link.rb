class CourtCouncilLink < ActiveRecord::Base
  attr_accessible :name, :court_id, :council_id, :area_of_law_id, :court, :council, :area_of_law
  belongs_to :court
  belongs_to :council
  belongs_to :area_of_law

  scope :by_name, -> { includes(:court).order('LOWER(courts.name)') }
end
