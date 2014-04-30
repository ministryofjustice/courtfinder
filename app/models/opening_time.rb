class OpeningTime < ActiveRecord::Base
  belongs_to :court
  belongs_to :opening_type
  attr_accessible :name, :sort, :court_id, :opening_type_id

  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip, location: :location}

  default_scope :order => :sort
end
