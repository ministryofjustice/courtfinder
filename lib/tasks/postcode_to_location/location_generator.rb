require 'yaml'
module Location
  class LocationGenerator
    attr_reader :modified_courts, :ignored_courts, :not_found_court_postcode
    attr_accessor :first_address

    def initialize(locations)
      @locations = locations
      @modified_courts = []
      @ignored_courts = []
      @not_found_court_postcode = []
    end

    def missing_location?(court)
      !court.locatable?
    end

    def generate_location_for(court)
      @first_address = court.addresses.first
      unless first_address
        @ignored_courts << court.name
        return false
      end

      courts_by_postcode(court)
    end

    def courts_by_postcode(court)
      postcode = first_address.postcode
      latitude, longitude = @locations.find(postcode)
      if latitude.present? && longitude.present?
        court.update_attributes(latitude: latitude, longitude: longitude)
        @modified_courts << court.name
      else
        @not_found_court_postcode << court.name
      end
    end

    def process(courts)
      courts.each do |court|
        generate_location_for(court) if missing_location?(court)
      end
    end

    def load(filename)
      courts = YAML.load_file(filename)
      courts.each do |info|
        Court.find_by(name: info["name"]).
          update_attributes(latitude: info["latitude"], longitude: info["longitude"])
        @modified_courts << info["name"]
        @not_found_court_postcode.delete(info["name"])
      end
    end
  end
end
