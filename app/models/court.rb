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
    :parking_offsite, :parking_blue_badge, :hide_aols

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :opening_times, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :court_facilities, allow_destroy: true

  before_validation :add_uuid
  before_validation :convert_visiting_to_location

  validates :name, presence: true
  validate :check_postcode_errors

  has_paper_trail ignore: [:created_at, :updated_at], meta: { ip: :ip }

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]

  geocoded_by latitude: :lat, longitude: :lng

  mount_uploader :image_file, CourtImagesUploader

  acts_as_gmappable process_geocoding: ->(obj) { obj.addresses.first.address_line_1.present? },
                    validation: false,
                    process_geocoding: false

  def gmaps4rails_address
    # describe how to retrieve the address from your model, if you use directly a db column,
    # you can dry your code, see wiki
    "#{addresses.first.address_line_1}, #{addresses.first.town.name},
     #{addresses.first.town.county.name}"
  end

  # Scope methods
  scope :visible,         -> { where(display: true) }
  scope :by_name,         -> { order('courts.name') }
  scope :by_area_of_law, lambda { |area_of_law|
    select('courts.*, lower(courts.name)').
      joins(:areas_of_law).uniq.
      where(areas_of_law: { name: area_of_law }) if area_of_law.present?
  }
  scope :search, ->(q) { where('courts.name ilike ?', "%#{q.downcase}%") if q.present? }
  scope :for_local_authority, lambda { |local_authority|
    joins(:local_authorities).
      where("local_authorities.name" => local_authority)
  }
  scope :for_local_authority_and_area_of_law, lambda { |local_authority, area_of_law|
    joins(:local_authorities).
      where("local_authorities.name" => local_authority,
            "remits.area_of_law_id" => "#{area_of_law.id}").
      order(:name)
  }
  scope :by_postcode_court_mapping, -> (postcode, area_of_law = nil) {
    if postcode.present?
      if postcode_court = PostcodeCourt.where("court_id IS NOT NULL AND ? like lower(postcode) || '%'",
            postcode.gsub(/\s+/, "").downcase).
            order('-length(postcode)').first
        # Using a reverse id lookup instead of just postcode_court.court as a workaround for the distance calculator
        if area_of_law
          by_area_of_law(area_of_law).where(id: postcode_court.court_id).limit(1)
        else
          where(id: postcode_court.court_id).limit(1)
        end
      else
        []
      end
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
      image_file.download!("https://hmctscourtfinder.justice.gov.uk/courtfinder/images/courts/#{image}")
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
    new_postcode_courts = []
    @postcode_errors = []
    postcodes.split(",").map do |postcode|
      postcode = postcode.gsub(/[^0-9a-z ]/i, "").downcase
      if pc = existing_postcode_court(postcode)
        if pc.court && pc.court == self
          new_postcode_courts << pc
        elsif pc.court && pc.court != self
          @postcode_errors << "Post code \"#{postcode}\" is already assigned to #{pc.court.name}. Please remove it from this court before assigning it to #{name}."
        end
      else
        new_postcode_courts << PostcodeCourt.new(postcode: postcode)
      end
    end
    self.postcode_courts = new_postcode_courts
  end

  def existing_postcode_court(postcode)
    PostcodeCourt.where("lower(postcode) = ?", postcode).first
  end

  def check_postcode_errors
    @postcode_errors.each { |e| errors.add(:postcode_courts, e) } if @postcode_errors
  end

  def visiting_addresses
    addresses.to_a.select { |a| AddressType.find(a.address_type_id).try(:name) != "Postal" }
  end

  def has_visiting_address?
    # Converting to array so that we get the addresses in memory, not the db record, otherwise validations don't work correctly.
    visiting_addresses.count > 0
  end

  def visiting_postcode
    visiting_addresses.first.try(:postcode)
  end

  def convert_visiting_to_location
    self.latitude = nil
    self.longitude = nil
    begin
      @cs = CourtSearch.new(visiting_postcode)
      lat_lon = @cs.latlng_from_postcode(visiting_postcode)
      if lat_lon
        self.latitude = lat_lon[0]
        self.longitude = lat_lon[1]
      end
    rescue Exception
      Rails.logger.error("Could not get latlng from: visiting_postcode")
    end
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

  def resolve_leaflets
    leaflets = %w(visitor defence prosecution juror)
    court_type = court_types.pluck('LOWER(name)')
    case
    when court_type.size >= 1 && court_type.include?("crown court")
      leaflets
    when court_type.size >= 1 && court_type.include?("magistrates court")
      leaflets.take(3)
    when court_type.any? { |ct| ct == "county court" || ct == "family court" || ct == "tribunal" }
      leaflets.take(1)
    else
      leaflets
    end
  end
end
