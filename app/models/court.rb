# == Schema Information
#
# Table name: courts
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  court_number          :integer
#  info                  :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  area_id               :integer
#  cci_code              :integer
#  old_id                :integer
#  old_court_type_id     :integer
#  slug                  :string(255)
#  old_postal_address_id :integer
#  old_court_address_id  :integer
#  latitude              :decimal(, )
#  longitude             :decimal(, )
#  old_image_id          :integer
#  image                 :string(255)
#  image_description     :string(255)
#  image_file            :string(255)
#  display               :boolean
#  gmaps                 :boolean
#  alert                 :string(255)
#  info_leaflet          :text
#  defence_leaflet       :text
#  prosecution_leaflet   :text
#  juror_leaflet         :text
#  cci_identifier        :integer
#  directions            :text
#  parking_onsite        :string(255)
#  parking_offsite       :string(255)
#  hide_aols             :boolean not null default:false
#

class Court < ActiveRecord::Base
  include Concerns::Court::LocalAuthorities
  include Concerns::Court::LocalAuthoritiesLists
  include Concerns::Court::PostcodeCourts

  belongs_to :area
  has_many :addresses
  has_many :opening_times
  has_many :contacts
  has_many :emails
  has_many :court_facilities
  has_many :court_types_courts
  has_many :court_types, through: :court_types_courts
  has_many :remits
  has_many :areas_of_law, through: :remits
  has_many :postcode_courts, dependent: :destroy

  attr_accessible :court_number, :info, :name, :slug, :area_id, :cci_code, :old_id,
    :old_court_type_id, :area, :addresses_attributes, :latitude, :longitude, :court_type_ids,
    :address_ids, :area_of_law_ids, :opening_times_attributes, :contacts_attributes,
    :emails_attributes, :court_facilities_attributes, :image, :image_file,
    :remove_image_file, :display, :alert, :info_leaflet, :defence_leaflet,
    :prosecution_leaflet, :juror_leaflet, :postcode_list, :directions, :parking_onsite,
    :parking_offsite, :parking_blue_badge, :hide_aols, :magistrate_court_location_code

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :opening_times, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :court_facilities, allow_destroy: true

  before_validation :add_uuid
  before_validation :convert_visiting_to_location
  before_validation :transliterate_slug

  validates :name, presence: true
  validate :check_postcode_errors

  validates :slug, format: /\A[a-zA-Z-]+\z/, allow_nil: true, if: :validate_slug?
  validates :name, format: /\A[a-zA-Z\s'\-\)\(,]+\z/, allow_nil: true
  has_paper_trail ignore: %i[created_at updated_at], meta: { ip: :ip }

  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged history finders]

  geocoded_by latitude: :lat, longitude: :lng

  mount_uploader :image_file, CourtImagesUploader

  # Scope methods
  scope :visible,         -> { where(display: true) }
  scope :by_name,         -> { order('courts.name') }
  scope :by_area_of_law, lambda { |area_of_law|
    return if area_of_law.blank?
    select('courts.*, lower(courts.name)').
      joins(:areas_of_law).uniq.
      where(areas_of_law: { name: area_of_law })
  }
  scope :search, ->(q) { where('courts.name ilike ?', "%#{q.downcase}%") if q.present? }
  scope :for_local_authority, lambda { |local_authority|
    joins(:local_authorities).
      where("local_authorities.name" => local_authority)
  }
  scope :for_local_authority_and_area_of_law, lambda { |local_authority, area_of_law|
    joins(:local_authorities).
      where("local_authorities.name" => local_authority,
            "remits.area_of_law_id" => area_of_law.id.to_s).
      order(:name)
  }
  scope :by_postcode_court_mapping, lambda { |postcode, area_of_law = nil|
    if postcode.present?
      postcode_court_lookup(postcode, area_of_law)
    else
      self
    end
  }

  def locatable?
    longitude && latitude && !addresses.visiting.empty?
  end

  def add_uuid
    self.uuid = UuidGenerator.new.generate if uuid.nil?
  end

  def fetch_image_file
    if image.present?
      image_url = "https://hmctscourtfinder.justice.gov.uk/courtfinder/images/courts/#{image}"
      image_file.download!(image_url)
      image_file.store!
    end
  end

  def leaflets
    @leaflets ||= resolve_leaflets
  end

  def is_county_court?
    court_types.any? { |ct| ct.name == 'County Court' }
  end

  def postcode_list
    postcode_courts.map(&:postcode).sort.join(", ")
  end

  def postcode_list=(postcodes)
    @new_postcode_courts = []
    @postcode_errors = []
    ingest_new_postcode_courts(postcodes)
    self.postcode_courts = @new_postcode_courts
  end

  def existing_postcode_court(postcode)
    ps_courts = PostcodeCourt.where("lower(postcode) = ?", postcode)
    ps_courts.first
  end

  def check_postcode_errors
    @postcode_errors.each { |e| errors.add(:postcode_courts, e) } if @postcode_errors
  end

  def visiting_addresses
    addresses.to_a.reject { |a| AddressType.find(a.address_type_id).try(:name) == "Postal" }
  end

  def has_visiting_address?
    # Converting to array so that we get the addresses in memory,
    # not the db record, otherwise validations don't work correctly.
    visiting_addresses.count > 0
  end

  def visiting_postcode
    visiting_addresses.first.try(:postcode)
  end

  def convert_visiting_to_location
    self.latitude, self.longitude = nil
    @cs = CourtSearch.new(visiting_postcode)
    lat_lon = @cs.latlng_from_postcode(visiting_postcode)
    if lat_lon
      self.latitude = lat_lon[0]
      self.longitude = lat_lon[1]
    end
  rescue NoMethodError
    Rails.logger.error("Could not get latlng from: visiting_postcode")
  end

  ParkingOption = Struct.new(:label, :value)

  def self.onsite_parking_options
    [
      ParkingOption.new(I18n.t('onsite_free'), "parking_onsite_free"),
      ParkingOption.new(I18n.t('onsite_paid'), "parking_onsite_paid"),
      ParkingOption.new(I18n.t('onsite_none'), "parking_onsite_none"),
      ParkingOption.new(I18n.t('onsite_no_info'), "")
    ]
  end

  def self.offsite_parking_options
    [
      ParkingOption.new(I18n.t('offsite_free'), "parking_offsite_free"),
      ParkingOption.new(I18n.t('offsite_paid'), "parking_offsite_paid"),
      ParkingOption.new(I18n.t('offsite_none'), "parking_offsite_none"),
      ParkingOption.new(I18n.t('offsite_no_info'), "")
    ]
  end

  def self.blue_badge_parking_options
    [
      ParkingOption.new(I18n.t('blue_badge_available'), "parking_blue_badge_available"),
      ParkingOption.new(I18n.t('blue_badge_limited'), "parking_blue_badge_limited"),
      ParkingOption.new(I18n.t('blue_badge_none'), "parking_blue_badge_none"),
      ParkingOption.new(I18n.t('blue_badge_no_info'), "")
    ]
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || changed.include?('name')
  end

  def transliterate_slug
    return if slug.blank?
    self.slug = ActiveSupport::Inflector.transliterate(slug).try(:downcase)
  end

  def validate_slug?
    changed.include?('slug')
  end

  def slug_candidates
    candidates = [:name]
    ('a'..'z').to_a.each { |letter| candidates << [:name, letter] }
    candidates
  end

  def resolve_leaflets
    if good_court_type_size? && court_type.include?("crown court")
      leaflets_list
    elsif good_court_type_size? && court_type.include?("magistrates court")
      leaflets_list.take(3)
    elsif any_cft_courts?
      leaflets_list.take(1)
    else
      leaflets_list
    end
  end

  def leaflets_list
    %w[visitor defence prosecution juror]
  end

  def good_court_type_size?
    court_type.size >= 1
  end

  def court_type
    @court_type ||= court_types.pluck('LOWER(name)')
  end

  def any_cft_courts?
    court_type.any? { |ct| ct == "county court" || ct == "family court" || ct == "tribunal" }
  end
end
