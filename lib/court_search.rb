require 'cgi/util'
require 'awesome_print' unless Rails.env.production?

class CourtSearch

  attr_accessor :query, :options

  def initialize(query, options={})
    @query = query && query.strip
    @options = options
    @errors = []
    @restclient = RestClient::Resource.new(Rails.application.config.postcode_lookup_service_url, timeout: 3, open_timeout: 1)
    RestClient.log = "#{Rails.root}/log/mapit_postcodes.log"
  end

  def errors
    @errors
  end

  def results
    courts = []
    if @query.blank?
      @errors << 'A search term must be provided'
    else
      if postcode_search?
        latlng = latlng_from_postcode(@query)
        if @chosen_area_of_law = AreaOfLaw.find_by_name(@options[:area_of_law])
          courts = postcode_area_search(@chosen_area_of_law, latlng)
        else
          courts = Court.visible.by_area_of_law(@options[:area_of_law]).near(latlng, @options[:distance] || 200).limit(20) if latlng
        end
        @errors << "We couldn't find that post code. Please try again." if courts.blank?
      else
        courts = Court.visible.by_area_of_law(@options[:area_of_law]).search(@query)
      end
    end
    courts.uniq
  end

  def lookup_council_name
    begin
      postcode_info = JSON.parse(@restclient[CGI::escape(@query)].get)
      county_id =  extract_council_from_county(postcode_info) || extract_council_from_council(postcode_info)
      postcode_info['areas'][county_id.to_s]['name']
    rescue => e
      Rails.logger.debug "Error: #{e.message}"
      Rails.logger.debug "Error: #{e.backtrace}"
      nil
    end
  end

  def extract_council_from_county(postcode_info)
    return nil if postcode_info['shortcuts']['council'].class == Fixnum
    postcode_info['shortcuts']['council']['county']
  end

  def extract_council_from_council(postcode_info)
    postcode_info['shortcuts']['council']
  end

  def postcode_search?
    # Allow full postcode (e.g. W4 1SE) or outgoing postcode (e.g. W4)
    @query =~ /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1})) ?(\d[abd-hjlnp-uw-z]{2})?)$/i
  end

  # private

  def postcode_area_search(area_of_law, latlng)
    if area_of_law.type_possession? || area_of_law.type_money_claims?
      courts = Court.visible.by_postcode_court_mapping(@query)
    elsif area_of_law.type_bankruptcy?
      #For Bankruptcy, we do an additional check that the postcode matched court also has Bankruptcy listed as an area of law
      courts = Court.visible.by_postcode_court_mapping(@query, @options[:area_of_law])
    elsif area_of_law.type_children? || area_of_law.type_adoption? || area_of_law.type_divorce?
      courts = Court.for_council_and_area_of_law(lookup_council_name, area_of_law)
    end

    if latlng
      if courts.present?
        # Calling near just so that court.distance works in the view, courts without location (lon, lat) are filtered out.
        courts = courts.near(latlng, 200, unit: :mi)
      else
        courts = Court.visible.by_area_of_law(@options[:area_of_law]).near(latlng, @options[:distance] || 200).limit(20)
        courts = courts.limit(1) if area_of_law.type_possession? || area_of_law.type_money_claims? || area_of_law.type_bankruptcy?
      end
    end
    courts
  end

  def latlng_from_postcode(postcode)
    begin
      results = JSON.parse(@restclient[CGI::escape(postcode)].get)
    rescue RestClient::BadRequest
      begin
        # if the postcode is just a part of a complete postcode, then the call above fails with BadRequest.
        results = JSON.parse(@restclient["/partial/#{CGI::escape(postcode)}"].get)
      rescue RestClient::ResourceNotFound
        results = not_found_error
      end
    rescue RestClient::ResourceNotFound
        results = not_found_error
    end
    [results['wgs84_lat'], results['wgs84_lon']] unless results['error']
  end

  def not_found_error
    {"code" => 404, "error" => "Postcode not found"}
  end

end
