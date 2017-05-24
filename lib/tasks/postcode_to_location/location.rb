require 'httparty'

module Location
  class Location
    include HTTParty

    base_uri 'http://pclookup.cjs.gov.uk'
    def find(postcode)
      postcode = postcode.tr(' ', '+')
      response = self.class.get("/postcode_finder.php?searchtext=#{postcode}&searchbtn=Search")
      begin
        response_lat = response["primary"]["coordinates"]["lat"]
        response_long = response["primary"]["coordinates"]["long"]
        return [response_lat, response_long]
      rescue
        return [nil, nil]
      end
    end
  end
end
