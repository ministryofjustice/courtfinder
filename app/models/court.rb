class Court < ActiveRecord::Base
  has_many :addresses
  has_many :opening_times
  has_many :contacts
  has_many :emails
  has_many :court_facilities
  has_many :court_types_courts
  has_many :court_types, :through => :court_types_courts
  has_many :courts_areas_of_law
  has_many :areas_of_law, :through => :courts_areas_of_law
  attr_accessible :court_number, :info, :name, :slug, :area_id, :cci_identifier, :cci_code, :old_id, :old_court_type_id, :area, :addresses_attributes, :latitude, :longitude, :court_type_ids, :area_of_law_ids, :opening_times_attributes, :contacts_attributes, :emails_attributes, :court_facilities_attributes, :image, :image_file
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :opening_times, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :court_facilities, allow_destroy: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  
  include Rails.application.routes.url_helpers

  geocoded_by :latitude => :lat, :longitude => :lng

  scope :visible, :conditions => { :display => true }

  mount_uploader :image_file, CourtImagesUploader

  # Text search
  def self.search(search)
    where('LOWER(name) like ?', "%#{search.downcase}%").order('name ASC')
  end

  def as_json(options={})
    {
      :area_id => self.area_id,
      :cci_code => self.cci_code,
      :cci_identifier => self.cci_identifier,
      :court_number => self.court_number,
      :created_at => self.created_at,
      :display => self.display,
      :id => self.id,
      :info => self.info,
      :latitude => self.latitude,
      :longitude => self.longitude,
      :name => self.name,
      :path => court_path(self),
      :slug => self.slug,
      :updated_at => self.updated_at
    }
  end

  def fetch_image_file
    require 'open-uri'
    self.image_file = open("http://hmctscourtfinder.justice.gov.uk/courtfinder/images/courts/#{self.image.to_s}") if image.present?
  rescue

  end

end
