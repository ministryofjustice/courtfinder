class Court < ActiveRecord::Base
  has_many :addresses
  attr_accessible :court_number, :info, :name, :slug, :area_id, :cci_identifier, :cci_code, :old_id, :old_court_type_id, :area, :addresses_attributes, :lat, :lng
  accepts_nested_attributes_for :addresses, allow_destroy: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  acts_as_geolocated lat: 'latitude', lng: 'longitude'

  # Text search
  def self.search(search, page, per_page)
    paginate :per_page => per_page,
             :page => page,
             :conditions => ['name like ?', "%#{search}%"],
             :order => 'name'
  end

end
