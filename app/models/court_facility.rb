class CourtFacility < ActiveRecord::Base
  belongs_to :court
  belongs_to :facility
  attr_accessible :description, :facility_id, :sort
  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip, network: :network}

  default_scope :order => :sort
end
