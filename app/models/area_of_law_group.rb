class AreaOfLawGroup < ActiveRecord::Base
  attr_accessible :name, :slug

  has_many :areas_of_law

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
end
