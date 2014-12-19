class CourtSerializer

  attr_reader :hash, :json, :md5

  def initialize(court_id)
    @court = Court.find(court_id)
    @hash = nil
    @json = nil
    @md5  = nil
  end


  def serialize
    @hash = serialize_court
  end


  private

  def serialize_court
    hash = {
      'name'          => @court.name,
      'slug'          => @court.slug,
      'updated_at'    => @court.graph_updated_at.strftime('%Y-%m-%dT%H:%M:%S.%4NZ'),
      'update_type'   => 'major',
      'locale'        => 'en',
      'closed'        => false,
      'alert'         => @court.alert,
      'lat'           => @court.latitude.to_s,
      'lon'           => @court.longitude.to_s,
      'court_number'  => @court.court_number,
      'DX'            => @court.dx_number,
      'areas_of_law'  => serialize_array(:areas_of_law),
      'facilities'    => serialize_array(:court_facilities),
      'parking'       => serialize_parking,
      'opening_times' => serialize_array(:opening_times),
      'addresses'     => serialize_array(:addresses),
      'contacts'      => serialize_array(:contacts),
      'emails'        => serialize_array(:emails)
    }
    hash
  end

  def serialize_array(collection_name)
    collection = @court.send(collection_name)
    array = []
    serialization_method = "serialize_#{collection_name}".to_sym
    collection.each { |c| array << send(serialization_method, c) }
    array
  end


  def serialize_areas_of_law(area_of_law)
    area_of_law.name
  end

  def serialize_court_facilities(court_facility)
    {
      'type'        => court_facility.facility.name,
      'description' => court_facility.description
    }
  end

  def serialize_parking
    array = []
    array << { 'onsite' => @court.parking_onsite } if @court.parking_onsite.present?
    array << { 'onsite' => @court.parking_offsite } if @court.parking_offsite.present?
    array << { 'onsite' => @court.parking_blue_badge } if @court.parking_blue_badge.present?
    array
  end

  def serialize_opening_times(opening_time)
    {
      'name' => opening_time.opening_type.name,
      'description' => opening_time.name
    }
  end

  def serialize_addresses(address)
    address_lines = [ address.address_line_1, address.address_line_2, address.address_line_3, address.address_line_4 ]
    {
      'type'     => address.address_type.name,
      'town'     => address.town.name,
      'county'   => address.town.county.name,
      'postcode' => address.postcode,
      'lines'    => address_lines.map{ |line| line if line.present? }.compact
    }
  end

  def serialize_contacts(contact)
    {
      'name' => contact.contact_type.name,
      'number' => contact.telephone
    }

  end

  def serialize_emails(email)
    contact_type = email.contact_type.nil? ? '' : email.contact_type.name
    {
      'name'    => contact_type,
      'address' => email.address
    }
  end


end
