class Court < ActiveRecord::Base
  has_many :addresses
  has_many :court_types_courts
  has_many :court_types, :through => :court_types_courts
  has_many :courts_areas_of_law
  has_many :areas_of_law, :through => :courts_areas_of_law
  attr_accessible :court_number, :info, :name, :slug, :area_id, :cci_identifier, :cci_code, :old_id, :old_court_type_id, :area, :addresses_attributes, :latitude, :longitude, :court_type_ids
  accepts_nested_attributes_for :addresses, allow_destroy: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  geocoded_by :latitude => :lat, :longitude => :lng

  # Text search
  def self.search(search, page, per_page)
    paginate :per_page => per_page,
             :page => page,
             :conditions => ['LOWER(name) like ?', "%#{search.downcase}%"],
             :order => 'name'
  end

end
