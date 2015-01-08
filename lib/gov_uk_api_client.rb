
class GovUkApiClient

  @@api_credentials = nil

  attr_reader :error_message, :public_url

  def initialize(action, uuid, json)
    unless [:create, :update, :delete].include?(action)
      raise "Unexpected action '#{action.inspect}' supplied to GovUkApiClient"
    end
    @action          = action
    @json            = json
    @uuid            = uuid
    @result          = false
    @response_body   = nil
    @response_status = nil
    @public_url      = nil
    @error_message   = nil
    load_credentials
  end

  def push
    if active?
      push_data
    else
      @result = true
    end
  end

  def success?
    @result
  end


  def reload_credentials
    unload_credentials
    load_credentials
  end

  def unload_credentials
    @@api_credentials = nil
  end


  private


  def active?
    @@api_credentials['active']
  end

  def push_data
    connection = Excon.new(endpoint)
    url = "#{endpoint}#{@uuid}"
    Excon.defaults[:ssl_verify_peer] = false
    response = Excon.put(url,
      :body => @json,
      :headers =>  { 
          'Accept'        => 'application/json', 
          'Content-Type'  => 'application/json',
          'Authorization' => "Bearer #{@@api_credentials['token']}"
      })

    @response_body = response.body        
    @response_status = response.status

    unless successful_response?(response)
      @result = false
      @error_message = "Response status: #{response.status}: #{response.body}"
      Rails.logger.error "GovUkApiError: #{@error_message}"
      raise GovUkApiError.new @error_message
    else
      begin
        @result = true
        @public_url = parse_successful_response_body
      rescue => err
        @error_message = "Invalid Response Body: #{@response_body}"
        Rails.logger.error "GovUkApiError: #{@error_message}"
        raise GovUkApiError.new @error_message
      end
    end
  end

  def parse_successful_response_body
    body = ActiveSupport::JSON.decode @response_body
    if !body.is_a?(Hash) && body.has_key?('public_url')
      msg = "Invalid success response received: satus: #{response.status}, body: #{response.body}"
      raise msg
    end
    body['public_url']
  end


  def successful_response?(response)
    case @action
    when :update
      response.status == 200 ? true : false
    when :create
      response.status == 201 ? true : false
    when :delete
      response.status == 200 ? true : false
    end

  end

 

  def load_credentials
    @@api_credentials ||= YAML.load_file("#{Rails.root}/config/gov_uk_api.yml")[Rails.env]
  end

  def endpoint
    @@api_credentials['endpoint']
  end

  def username
    @@api_credentials['username']
  end

  def password
    @@api_credentials['password']
  end



end