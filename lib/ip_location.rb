module IpLocation
  def self.find(ip)
    url = "http://freegeoip.net/json/#{ip}"
    attributes = ['country_name', 'region_name', 'city']
    location = JSON.parse(RestClient.get(url))
    format(location.slice(*attributes).values.compact)
  end

  private

    def format(details)
      if details.count == 1 && == 'Reserved'
        'localhost'
      elsif details.count == 1
        details.first
      else
        detsails.join('->')
      end
    end
end