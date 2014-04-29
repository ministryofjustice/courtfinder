module IpLocation
  def self.find(ip)
    url = "http://freegeoip.net/json/#{ip}"
    attributes = ['country_name', 'region_name', 'city']
    location = JSON.parse(RestClient.get(url))
    location.slice(*attributes).values.compact.join(' ')
  end
end