class ExternalLink < ActiveRecord::Base
  attr_accessible :text, :url, :always_visible
  has_and_belongs_to_many :court_types
  has_and_belongs_to_many :areas_of_law

  scope :visible, ->{ where(always_visible: true) }
end
