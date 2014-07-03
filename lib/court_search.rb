require 'cgi/util'
require 'awesome_print' unless Rails.env.production?

class CourtSearch

  attr_accessor :query, :options
  attr_accessor :postcode_info

  def initialize(query, options={})
    @query = query && query.strip
    @options = options
    @errors = []
    @restclient = RestClient::Resource.new(Rails.application.config.postcode_lookup_service_url, timeout: 3, open_timeout: 1)
    RestClient.log = "#{Rails.root}/log/mapit_postcodes.log"
    @postcode_info = nil
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
        @chosen_area_of_law = AreaOfLaw.find_by_name(@options[:area_of_law])
        if @chosen_area_of_law.present?
          courts = postcode_area_search(@chosen_area_of_law, latlng)
        else
          courts = Court.visible.by_area_of_law(@options[:area_of_law]).near(latlng, @options[:distance] || 200).limit(20) if latlng
        end
        @errors << "We couldn't find that post code. Please try again." if courts.blank?
      else
        courts = Court.visible.by_area_of_law(@options[:area_of_law]).search(@query)
      end
    end
    {
      found_in_area_of_law: found_in_area_of_law(courts),
      courts: courts
    }
  end

  def lookup_council_name
    begin
      Rails.logger.debug("postcode info")
      Rails.logger.debug(@postcode_info)
      county_id = extract_council_from_county(@postcode_info) || extract_council_from_council(@postcode_info)
      postcode_info['areas'][county_id.to_s]['name']
    rescue => e
      Rails.logger.debug "Error: #{e.message}"
      Rails.logger.debug "Error: #{e.backtrace}"
      nil
    end
  end

  def extract_council_from_county(postcode_info)
    return nil if postcode_info['shortcuts']['council'].class == Fixnum rescue nil
    postcode_info['shortcuts']['council']['county']
  end

  def extract_council_from_council(postcode_info)
    postcode_info['shortcuts']['council']
  end

  def postcode_search?
    # Allow full postcode (e.g. W4 1SE) or outgoing postcode (e.g. W4)
    @query =~ /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1})) ?(\d[abd-hjlnp-uw-z]{2})?)$/i
  end

  def postcode_area_search(area_of_law, latlng)
    if area_of_law.type_possession? || area_of_law.type_money_claims?
      courts = Court.visible.by_postcode_court_mapping(@query)
    elsif area_of_law.type_bankruptcy?
      #For Bankruptcy, we do an additional check that the postcode matched court also has Bankruptcy listed as an area of law
      courts = Court.visible.by_postcode_court_mapping(@query, @options[:area_of_law])
    elsif area_of_law.type_children? || area_of_law.type_adoption? || area_of_law.type_divorce?
      courts = Court.by_area_of_law(@options[:area_of_law]).for_council_and_area_of_law(lookup_council_name, area_of_law)
    end

    if latlng
      if courts.present?
        # Calling near just so that court.distance works in the view, courts without location (lon, lat) are filtered out.
        courts_with_distance = courts.near(latlng, 200, unit: :mi)
        courts_without_distance = courts - courts_with_distance
        courts = courts_with_distance + courts_without_distance
      else
        courts = Court.visible.by_area_of_law(@options[:area_of_law]).near(latlng, @options[:distance] || 200).limit(20)
        courts = courts.limit(1) if area_of_law.type_possession? || area_of_law.type_money_claims? || area_of_law.type_bankruptcy?
      end
    end
    courts
  end

  def latlng_from_postcode(postcode)
    @postcode_info = make_request(postcode)
    Rails.logger.info("Internal lookup: #{postcode}")

    [@postcode_info['wgs84_lat'], @postcode_info['wgs84_lon']] unless @postcode_info['error']
  end

  def make_request(postcode, client=@restclient)
    partial_or_full = ->(postcode, client) do
      if postcode.strip.size <= 4
        partial_postcode_request(postcode, client)
      else
        full_postcode_request(postcode, client)
      end
    end

    begin
      partial_or_full.(postcode, client)
    rescue RestClient::BadRequest
      bad_request_error
    rescue RestClient::ResourceNotFound
      via_mapit(postcode){ partial_or_full }
    rescue RestClient::ServerBrokeConnection
      via_mapit(postcode){ partial_or_full }
    rescue RestClient::RequestFailed
      via_mapit(postcode){ partial_or_full }
    end
  end

  def via_mapit(postcode)
    Rails.logger.info("Mapit lookup: #{postcode}")
    client = RestClient::Resource.new(Rails.application.config.backup_postcode_lookup_service_url, timeout: 3, open_timeout: 1)
    begin
      if block_given?
        yield.(postcode, client)
      else
        JSON.parse(client[CGI::escape(postcode)].get)
      end
    rescue RestClient::BadRequest
      bad_request_error
    rescue RestClient::ResourceNotFound
      not_found_error
    rescue RestClient::ServerBrokeConnection
      internal_server_error
    rescue RestClient::RequestFailed
      internal_server_error
    end
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
      {code: 404, error: "Postcode not found"}
    end

    def internal_server_error
      {code: 500, error: "Internal server error"}
    end

    def bad_request_error
      {code: 400, error: "HTTP Error Bad request"}
    end

    def partial_postcode_request(postcode, client)
      begin
        # if the postcode is just a part of a complete postcode, then the call above fails with BadRequest.
        JSON.parse(client["/partial/#{CGI::escape(postcode)}"].get)
      rescue RestClient::ResourceNotFound
        not_found_error
      end
    end

    def full_postcode_request(postcode, client)
      begin
        JSON.parse(client[CGI::escape(postcode)].get)
      rescue RestClient::ResourceNotFound
        not_found_error
      end
    end
end
