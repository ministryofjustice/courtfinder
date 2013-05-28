class Court < ActiveRecord::Base
  belongs_to :area
  has_many :addresses
  has_many :opening_times
  has_many :contacts
  has_many :emails
  has_many :court_facilities
  has_many :court_types_courts
  has_many :court_types, :through => :court_types_courts
  has_many :courts_areas_of_law
  has_many :areas_of_law, :through => :courts_areas_of_law
  attr_accessible :court_number, :info, :name, :slug, :area_id, :cci_identifier, :cci_code, :old_id, :old_court_type_id, :area, :addresses_attributes, :latitude, :longitude, :court_type_ids, :area_of_law_ids, :opening_times_attributes, :contacts_attributes, :emails_attributes, :court_facilities_attributes, :image, :image_file, :remove_image_file, :display
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :opening_times, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :court_facilities, allow_destroy: true
  validates_presence_of :name

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  
  include Rails.application.routes.url_helpers

  geocoded_by :latitude => :lat, :longitude => :lng

  mount_uploader :image_file, CourtImagesUploader

  acts_as_gmappable :process_geocoding => lambda { |obj| obj.addresses.first.address_line_1.present? },
                    :validation => false,
                    :process_geocoding => false

  def gmaps4rails_address
  #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.addresses.first.address_line_1}, #{self.addresses.first.town.name}, #{self.addresses.first.town.county.name}"
  end

  # Scope methods
  def self.visible
    where(:display => true)
  end

  def self.by_area_of_law(area_of_law)
    if area_of_law.present?
      joins(:areas_of_law).where(:areas_of_law => {:name => area_of_law})
    else
      where('')
    end
  end

  def self.search(q)
    where('courts.name ilike ?', "%#{q.downcase}%") if q.present?
  end


  def as_json(options={})
    if options[:lookup]
      [
        self.name,
        self.slug
      ]
    else
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
  end

  def fetch_image_file
    require 'open-uri'
    self.image_file = open("http://hmctscourtfinder.justice.gov.uk/courtfinder/images/courts/#{self.image.to_s}") if image.present?
  rescue

  end

end
