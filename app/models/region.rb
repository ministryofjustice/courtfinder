class Region < ActiveRecord::Base
  has_many :areas
  attr_accessible :name

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
end
