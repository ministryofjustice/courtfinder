class CourtTypesCourt < ActiveRecord::Base
  belongs_to :court
  belongs_to :court_type
  attr_accessible :court_id, :court_type_id
  has_paper_trail meta: {ip: :ip, location: :location}
end
