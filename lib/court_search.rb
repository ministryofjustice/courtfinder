class CourtSearch
  
  attr_accessor :query, :options
  
  def initialize(query, options={})
    @query = query
    @options = options
  end

  def results
    if postcode_search?
      {:courts => search_postcode, :areas_of_law => []}
    else
      {:courts => Court.search(@query, @options), :areas_of_law => AreaOfLaw.search(@query)}
    end
  end

  def courts
    results[:courts]
  end

  def areas_of_law
    results[:areas_of_law]
  end

  def search_postcode
    # Use the geocoder near method to find venues within the specified radius
    Court.by_area_of_law(@options[:area_of_law]).near(latlng_from_postcode(@query), @options[:distance] || 20)
  end

  def latlng_from_postcode(postcode)
    # Use PHP postcode service to turn postcode into lat/lon
    service_available = Rails.application.config.postcode_lookup_service_url rescue false
    json = RestClient.get Rails.application.config.postcode_lookup_service_url, :params => { :searchtext => postcode, :searchbtn => 'Search' }
    results = JSON.parse json
    [results['primary']['coordinates']['lat'], results['primary']['coordinates']['long']]
  end

  def postcode_search?
    @query =~ /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1}))\d[abd-hjlnp-uw-z]{2})$/i
  end
end