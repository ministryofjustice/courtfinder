class CourtSearch
  
  attr_accessor :query, :options
  
  def initialize(query, options={})
    @query = query && query.strip
    @options = options
    @errors = []
    @restclient = RestClient::Resource.new(Rails.application.config.postcode_lookup_service_url, timeout: 3, open_timeout: 1)
  end

  def errors
    @errors
  end

  def results
    if !@query.present?
      @errors << 'A search term must be provided'
      []
    else
      if postcode_search?
        if latlng = latlng_from_postcode(@query)
          Court.visible.by_area_of_law(@options[:area_of_law]).near(latlng, @options[:distance] || 200).limit(20)
        else
          @errors << "We couldn't find that post code. Please try again."
          []
        end
      else
        Court.visible.by_area_of_law(@options[:area_of_law]).search(@query)
      end
    end
  end

  def latlng_from_postcode(postcode)
    # Use PHP postcode service to turn postcode into lat/lon
    results = JSON.parse(@restclient.get(:params => { :searchtext => postcode, :searchbtn => 'Search' }))
    [results['primary']['coordinates']['lat'], results['primary']['coordinates']['long']] unless results['error']
  end

  def postcode_search?
    # Allow full postcode (e.g. W4 1SE) or outgoing postcode (e.g. W4)
    @query =~ /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1})) ?(\d[abd-hjlnp-uw-z]{2})?)$/i
  end
end
