require 'cgi/util'
require 'awesome_print' unless Rails.env.production?

class CourtSearch

  attr_accessor :query, :options, :errors
  attr_accessor :postcode_info

  def initialize(query, options = {})
    @query = query && query.strip
    @options = options
    @errors = []
    lookup_url = Rails.application.config.postcode_lookup_service_url
    @restclient = RestClient::Resource.new(lookup_url, timeout: 3, open_timeout: 1)
    RestClient.log = Rails.root.join('log', 'mapit_postcodes.log').to_s
    @postcode_info = nil
  end

  def results
    courts = []

    if valid_for_search? && postcode_search?
      courts = courts_finder
      if courts.blank?
        @errors << "We couldn't find that post code. Please try again."
      end
    else
      courts = Court.visible.by_area_of_law(@options[:area_of_law]).search(@query)
    end
    result_hash(courts)
  end

  def lookup_local_authority_name
    Rails.logger.debug("postcode info")
    Rails.logger.debug(@postcode_info)
    county_id = extract_local_authority
    postcode_info['areas'][county_id.to_s]['name']
  rescue => e
    Rails.logger.debug "Error: #{e.message}"
    Rails.logger.debug "Error: #{e.backtrace}"
    nil
  end

  def extract_local_authority_from_county(postcode_info)
    return nil if postcode_info['shortcuts']['council'].class == Integer
    postcode_info['shortcuts']['council']['county']
  rescue
    nil
  end

  def extract_local_authority_from_council(postcode_info)
    postcode_info['shortcuts']['council']
  end

  def query_is_in_northern_ireland?
    # BT is the prefix for postcodes in Northern Ireland
    @query.match(/^BT/i) != nil
  end

  def area_of_law_is_valid_for_northern_ireland?
    @options[:area_of_law] == "Immigration"
  end

  def postcode_search?
    # Allow full postcode (e.g. W4 1SE) or outgoing postcode (e.g. W4)
    @query =~ /
      ^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|
        ([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|
        ([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|
        ([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1}))
         ?(\d[abd-hjlnp-uw-z]{2})?)$
      /ix
  end

  def postcode_area_search(area_of_law, latlng)
    courts = courts_by_area_of_law(area_of_law)

    if latlng
      courts = courts_by_lat_long(area_of_law, latlng)
    end
    courts
  end

  def latlng_from_postcode(postcode)
    @postcode_info = make_request(postcode)
    Rails.logger.info("Internal lookup: #{postcode}")

    [@postcode_info['wgs84_lat'], @postcode_info['wgs84_lon']] unless @postcode_info['error']
  end

  def make_request(postcode_value, client_value = @restclient)
    partial_or_full = lambda do |postcode, client|
      if postcode.strip.size <= 4
        partial_postcode_request(postcode, client)
      else
        full_postcode_request(postcode, client)
      end
    end

    request_call(partial_or_full, postcode_value, client_value)
  end

  private

  def found_in_area_of_law(courts)
    if @chosen_area_of_law.present? && courts.present? && courts.respond_to?(:count)
      courts.count
    else
      0
    end
  end

  def not_found_error
    { code: 404, error: "Postcode not found" }
  end

  def internal_server_error
    { code: 500, error: "Internal server error" }
  end

  def bad_request_error
    { code: 400, error: "HTTP Error Bad request" }
  end

  def partial_postcode_request(postcode, client)
    # if the postcode is just a part of a complete postcode,
    # then the call above fails with BadRequest.
    JSON.parse(client["/partial/#{CGI.escape(postcode)}"].get)
  rescue RestClient::ResourceNotFound
    not_found_error
  end

  def full_postcode_request(postcode, client)
    JSON.parse(client[CGI.escape(postcode)].get)
  rescue RestClient::ResourceNotFound
    not_found_error
  end

  def courts_finder
    latlng = latlng_from_postcode(@query)

    @chosen_area_of_law = AreaOfLaw.find_by(name: @options[:area_of_law])
    if @chosen_area_of_law.present?
      courts = postcode_area_search(@chosen_area_of_law, latlng)
    elsif latlng
      courts = Court.visible.by_area_of_law(@options[:area_of_law]).
               near(latlng, @options[:distance] || 200).limit(20)
    end
    courts
  end

  def result_hash(courts)
    {
      found_in_area_of_law: found_in_area_of_law(courts),
      courts: courts
    }
  end

  def valid_for_search?
    if @query.blank?
      @errors << 'A search term must be provided'
      return false
    elsif query_is_in_northern_ireland? &&
          !area_of_law_is_valid_for_northern_ireland?
      @errors << "We are sorry, Northern Ireland is not supported by this tool"
    end
    true
  end

  def extract_local_authority
    extract_local_authority_from_county(@postcode_info) ||
      extract_local_authority_from_council(@postcode_info)
  end

  def courts_by_area_of_law(area_of_law)
    if area_of_law.type_possession? || area_of_law.type_money_claims?
      Court.visible.by_postcode_court_mapping(@query)
    elsif area_of_law.type_bankruptcy?
      # For Bankruptcy, we do an additional check that the postcode
      # matched court also has Bankruptcy listed as an area of law
      Court.visible.by_postcode_court_mapping(@query, @options[:area_of_law])
    elsif local_authority_area_of_law?(area_of_law)
      Court.by_area_of_law(@options[:area_of_law]).
        for_local_authority_and_area_of_law(lookup_local_authority_name, area_of_law)
    end
  end

  def local_authority_area_of_law?(area_of_law)
    area_of_law.type_children? || area_of_law.type_adoption? || area_of_law.type_divorce?
  end

  def courts_by_lat_long(area_of_law, latlng)
    if courts.present?
      # Calling near just so that court.distance works in the view,
      # courts without location (lon, lat) are filtered out.
      courts_with_distance = courts.near(latlng, 200, unit: :mi)
      courts_without_distance = courts - courts_with_distance
      courts_with_distance + courts_without_distance
    else
      court_visible_by_area_of_law(latlng)
      if limit_courts_results?(area_of_law)
        courts.limit(1)
      end
    end
  end

  def limit_courts_results?(area_of_law)
    area_of_law.type_possession? ||
      area_of_law.type_money_claims? ||
      area_of_law.type_bankruptcy?
  end

  def court_visible_by_area_of_law(latlng)
    Court.visible.by_area_of_law(@options[:area_of_law]).
      near(latlng, @options[:distance] || 200).limit(20)
  end

  def request_call(partial_or_full, postcode, client)
    partial_or_full.call(postcode, client)
  rescue RestClient::BadRequest
    bad_request_error
  rescue StandardError
    via_mapit(postcode) { partial_or_full }
  end

  def via_mapit(postcode)
    mapit_postcodes(postcode)
  rescue RestClient::BadRequest
    bad_request_error
  rescue RestClient::ResourceNotFound
    not_found_error
  rescue RestClient::ServerBrokeConnection, RestClient::RequestFailed
    internal_server_error
  end

  def mapit_postcode(postcode)
    Rails.logger.info("Mapit lookup: #{postcode}")
    lookup_url = Rails.application.config.backup_postcode_lookup_service_url
    client = RestClient::Resource.new(lookup_url, timeout: 3, open_timeout: 1)
    if block_given?
      yield.call(postcode, client)
    else
      JSON.parse(client[CGI.escape(postcode)].get)
    end
  end
end
