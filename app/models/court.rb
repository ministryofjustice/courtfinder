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
  has_many :postcode_courts
  attr_accessible :court_number, :info, :name, :slug, :area_id, :cci_identifier, :cci_code, :old_id, 
                  :old_court_type_id, :area, :addresses_attributes, :latitude, :longitude, :court_type_ids, 
                  :area_of_law_ids, :opening_times_attributes, :contacts_attributes, :emails_attributes, 
                  :court_facilities_attributes, :image, :image_file, :remove_image_file, :display, :alert,
                  :info_leaflet, :defence_leaflet, :prosecution_leaflet, :juror_leaflet,
                  :postcode_list

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :opening_times, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :court_facilities, allow_destroy: true
  validates_presence_of :name, :latitude, :longitude

  validates :latitude, numericality: { greater_than:  -90, less_than:  90 }
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }

  has_paper_trail :ignore => [:created_at, :updated_at]

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

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

  def self.by_name
    order('LOWER(name)') # ignore case when sorting
  end

  def self.by_area_of_law(area_of_law)
    if area_of_law.present?
      joins(:areas_of_law).where(:areas_of_law => {:name => area_of_law})
    else
      where('')
    end
  end

  def self.by_postcode_court_mapping(postcode, area_of_law = nil)
    if postcode.present?
      if postcode_court = PostcodeCourt.where("court_id IS NOT NULL AND ? like lower(postcode) || '%'", 
                                              postcode.gsub(/\s+/, "").downcase)
                                        .order('-length(postcode)').first
        #Using a reverse id lookup instead of just postcode_court.court as a workaround for the distance calculator
        if area_of_law
          joins(:areas_of_law).where(:areas_of_law => {:name => area_of_law})
          .where(:id => postcode_court.court_id).limit(1)
        else
          where(:id => postcode_court.court_id).limit(1)
        end
      else
        []
      end
    else
      where('')
    end
  end

  def self.search(q)
    where('courts.name ilike ?', "%#{q.downcase}%") if q.present?
  end


  def locatable?
    longitude && latitude && !addresses.visiting.empty?
  end

  def fetch_image_file
    if image.present?
      self.image_file.download!("http://hmctscourtfinder.justice.gov.uk/courtfinder/images/courts/#{self.image.to_s}")
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
    # 31 is the ID of county court
    court_types.pluck(:id).include? 31
  end

  def postcode_list
    postcode_courts.map(&:postcode).sort.join(", ")
  end

  def postcode_list=(postcodes)
    new_postcode_courts = []
    postcodes.split(",").map do |postcode|
      postcode = postcode.gsub(/\s+/, "").downcase
      existing_pc = PostcodeCourt.where("lower(postcode) = ? AND court_id is not null AND court_id != #{self.id}", postcode)
      if existing_pc.empty?
        new_postcode_courts << PostcodeCourt.create!(postcode: postcode)
      end
    end
    self.postcode_courts = new_postcode_courts
  end
  true
end
