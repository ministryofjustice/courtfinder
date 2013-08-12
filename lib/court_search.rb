class CourtSearch
  
  attr_accessor :query, :options
  
  def initialize(query, options={})
    @query = query
    @options = options
    @errors = []
    @restclient = RestClient::Resource.new(Rails.application.config.postcode_lookup_service_url, timeout: 3, open_timeout: 1)
  end

  def results
    if postcode_search?
      search_postcode
    else
      Court.visible.by_area_of_law(@options[:area_of_law]).search(@query)
    end
  end

  def search_postcode
    # Use the geocoder near method to find venues within the specified radius
    latlon = latlng_from_postcode(@query)
    # if latlon
      Court.visible.by_area_of_law(@options[:area_of_law]).near(latlon, @options[:distance] || 20)
    # else
      # @errors.push 'This is an error'
      # return nil
    # end
  end

  def latlng_from_postcode(postcode)
    # Use PHP postcode service to turn postcode into lat/lon
    service_available = Rails.application.config.postcode_lookup_service_url rescue false
    json = @restclient.get(:params => { :searchtext => postcode, :searchbtn => 'Search' })
    results = JSON.parse json
    [results['primary']['coordinates']['lat'], results['primary']['coordinates']['long']]
  end

  def postcode_search?
    # Allow full postcode (e.g. W4 1SE) only
    # @query =~ /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1}))\d[abd-hjlnp-uw-z]{2})$/i
    # Allow full postcode (e.g. W4 1SE) or outgoing postcode (e.g. W4)
    @query =~ /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1})) ?(\d[abd-hjlnp-uw-z]{2})?)$/i
  end
end
