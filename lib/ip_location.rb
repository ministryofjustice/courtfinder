module IpLocation
  def self.find(ip)
    url = "http://freegeoip.net/json/#{ip}"
    attributes = ['country_name', 'region_name', 'city']
    location = JSON.parse(RestClient.get(url))
    format(location.slice(*attributes).values.compact)
  end

  private

    def self.format(details)
      if details.first == "Reserved"
        'LOCALHOST'
      elsif details.count == 1
        details.first
      else
        details.join('->')
      end
    end
end