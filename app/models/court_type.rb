class CourtType < ActiveRecord::Base
  attr_accessible :name, :old_id
  has_many :court_types_courts
  has_many :courts, :through => :court_types_courts
end
