module IpLocation
  def self.find(ip)
    location = lookup_ip(ip)
    format(interesting_location_values(location))
  end

  private
    def self.interesting_location_values(location)
      attributes = ['country_name', 'region_name', 'city']
      location.slice(*attributes).values.compact
    end

    def self.lookup_ip(ip)
      location = JSON.parse(RestClient.get(make_url(ip)))
    end

    def self.make_url(ip)
      "http://freegeoip.net/json/#{ip}"
    end

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