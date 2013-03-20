class Facility < ActiveRecord::Base
  has_many :court_facilities
  attr_accessible :image, :name
end
