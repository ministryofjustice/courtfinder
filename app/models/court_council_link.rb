class CourtCouncilLink < ActiveRecord::Base
  belongs_to :court
  belongs_to :council
end
