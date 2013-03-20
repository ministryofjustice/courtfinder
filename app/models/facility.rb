class Facility < ActiveRecord::Base
  has_many :court_facilities
  attr_accessible :image, :name, :image_description
end
