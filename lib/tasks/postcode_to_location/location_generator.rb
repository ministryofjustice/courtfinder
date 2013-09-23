module Location
 class LocationGenerator
    attr_reader :modified_courts, :ignored_courts, :not_found_court_postcode
    def initialize(locations)
      @locations = locations
      @modified_courts = []
      @ignored_courts = []
      @not_found_court_postcode = []
    end

    def missing_location?(court)
      ! court.locatable?
    end

    def generate_location_for(court)
      first_address = court.addresses.first
      unless first_address
        @ignored_courts << court.name
        return false
      end

      postcode = first_address.postcode
      latitude, longitude  =  @locations.find(postcode)
      unless latitude.nil? && longitude.nil?
        court.update_attributes({latitude: latitude, longitude: longitude})
        @modified_courts << court.name
      else
        @not_found_court_postcode << court.name
        return false
      end
      true
    end

    def process(courts)
      courts.each do |court|
        generate_location_for(court) if missing_location?(court)
      end
    end
  end
end
