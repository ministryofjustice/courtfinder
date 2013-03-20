class FacilityType < ActiveRecord::Base
  has_many :facilities
  attr_accessible :image, :name
end
