class Court < ActiveRecord::Base
  include Concerns::Court::Councils

  belongs_to :area
  has_many :addresses
  has_many :opening_times
  has_many :contacts
  has_many :emails
  has_many :court_facilities
  has_many :court_types_courts
  has_many :court_types, through: :court_types_courts
  has_many :courts_areas_of_law
  has_many :areas_of_law, through: :courts_areas_of_law
  has_many :postcode_courts, dependent: :destroy


  attr_accessible :court_number, :info, :name, :slug, :area_id, :cci_code, :old_id,
                  :old_court_type_id, :area, :addresses_attributes, :latitude, :longitude, :court_type_ids,
                  :address_ids, :area_of_law_ids, :opening_times_attributes, :contacts_attributes, :emails_attributes,
                  :court_facilities_attributes, :image, :image_file, :remove_image_file, :display, :alert,
                  :info_leaflet, :defence_leaflet, :prosecution_leaflet, :juror_leaflet,
                  :postcode_list

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :opening_times, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :court_facilities, allow_destroy: true

  before_validation :convert_visiting_to_location

  validates :name, presence: true

  validates :latitude, numericality: { greater_than:  -90, less_than:  90 }, presence: true, if: :has_visiting_address?
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }, presence: true, if: :has_visiting_address?

  validate :check_postcode_errors

  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip, location: :location}

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  geocoded_by latitude: :lat, longitude: :lng

  mount_uploader :image_file, CourtImagesUploader

  acts_as_gmappable :process_geocoding => lambda { |obj| obj.addresses.first.address_line_1.present? },
                    :validation => false,
                    :process_geocoding => false

  def gmaps4rails_address
  #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.addresses.first.address_line_1}, #{self.addresses.first.town.name}, #{self.addresses.first.town.county.name}"
  end

  # Scope methods
  scope :visible,         -> { where(display: true) }
  scope :by_name,         -> { order('LOWER(courts.name)') }
  scope :by_area_of_law,  -> (area_of_law) { joins(:areas_of_law).where(areas_of_law: {name: area_of_law}) if area_of_law.present? }
  scope :search,          -> (q) { where('courts.name ilike ?', "%#{q.downcase}%") if q.present? }
  scope :for_council,     -> (council) { joins(:councils).where("councils.name" => council) }
  scope :for_council_and_area_of_law, -> (council, area_of_law) {
    joins(:councils).where("councils.name" => council, "court_council_links.area_of_law_id" => "#{area_of_law.id}")
  }
  scope :by_postcode_court_mapping, -> (postcode, area_of_law = nil) {
    if postcode.present?
      if postcode_court = PostcodeCourt.where("court_id IS NOT NULL AND ? like lower(postcode) || '%'",
            postcode.gsub(/\s+/, "").downcase)
            .order('-length(postcode)').first
        #Using a reverse id lookup instead of just postcode_court.court as a workaround for the distance calculator
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

  def fetch_image_file
    if image.present?
      self.image_file.download!("https://hmctscourtfinder.justice.gov.uk/courtfinder/images/courts/#{self.image.to_s}")
      self.image_file.store!
    end
  end

  def leaflets
    @leaflets || begin
      @leaflets = []
      if self.court_types.empty? || self.court_types.pluck(:name).any? {|ct| ct != "Family Proceedings Court" && ct != "County Court" && ct != "Tribunal"}
        @leaflets.push("defence", "prosecution")
      end
      if self.court_types.pluck(:name).any? {|ct| ct == "Crown Court"}
        @leaflets << "juror"
      end
      @leaflets
    end
  end

  def is_county_court?
    court_types.any?{|ct| ct.name == 'County Court'}
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
          @postcode_errors << "Post code \"#{postcode}\" is already assigned to #{pc.court.name}. Please remove it from this court before assigning it to #{self.name}."
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
    @postcode_errors.each {|e| errors.add(:postcode_courts, e) } if @postcode_errors
  end

  def visiting_addresses
    addresses.to_a.select { |a| AddressType.find(a.address_type_id).try(:name) == "Visiting" }
  end

  def has_visiting_address?
    #Converting to array so that we get the addresses in memory, not the db record, otherwise validations don't work correctly.
    visiting_addresses.count > 0
  end

  def convert_visiting_to_location
    if visiting_postcode = visiting_addresses.first.try(:postcode)
      begin
        @cs = CourtSearch.new(visiting_postcode)
        if lat_lon = @cs.latlng_from_postcode(visiting_postcode)
          self.latitude = lat_lon[0]
          self.longitude = lat_lon[1]
        end
      rescue Exception => ex
        Rails.logger.error("Could not get latlng from: visiting_postcode")
      end
    else
      self.latitude = nil
      self.longitude = nil
    end
  end
end
