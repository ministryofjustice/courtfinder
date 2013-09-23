require 'httparty'

module Location
  class Location
    include HTTParty

    base_uri 'http://pclookup.cjs.gov.uk'
    def find(postcode)
      postcode = postcode.gsub(' ', '+')
      response = self.class.get("/postcode_finder.php?searchtext=#{postcode}&searchbtn=Search")
      begin
        return [response["primary"]["coordinates"]["lat"], response["primary"]["coordinates"]["long"]]
      rescue
        return [nil, nil]
      end
    end
  end
end
