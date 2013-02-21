class Court < ActiveRecord::Base
  attr_accessible :court_number, :info, :name
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
end
