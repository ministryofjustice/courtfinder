require 'spec_helper'
require File.dirname(__FILE__) + '/../mocks/mock_gov_uk_json'

describe GovUkApiClient do

  let(:json)      { MockGovUkJson.expected_hash.to_json }
  let(:uuid)      { '5bc22c4d-51da-4788-876a-67b4928def88' }

  describe '.new' do
    it 'should load the test deve credentials' do
      client = GovUkApiClient.new(:update, uuid, json)
      expect(client.send(:endpoint)).to eq "https://#{testing_endpoint}/courts/"
    end

    it 'should raise error if unexpected action given' do
      expect {
        client = GovUkApiClient.new(:modify, uuid, json)
      }.to raise_error RuntimeError, "Unexpected action ':modify' supplied to GovUkApiClient"
    end

  end



  # this is a test which is here just while I'm developing so I have an easy way of testing that we can 
  # actually get to the endpoints
  #
  describe '#push to a real endpoint' do
    it 'should put and get a response' do
      VCR.configure do |c|
        c.ignore_request do |request|
          URI(request.uri).host == testing_endpoint
        end
      end
      client = GovUkApiClient.new(:update, uuid, json)
      client.push
      expect(client.instance_variable_get(:@response_status)).to eq 200
      expect(client.instance_variable_get(:@response_body)).to eq %Q<{"public_url":"https://#{testing_endpoint}/courts/public/my-test-court"}>
    end
  end


  describe '#push' do

    let(:response_headers) do
      {
             "Connection" => "close",
                 "Server" => "gunicorn/19.1.1",
                   "Date" => "Tue, 23 Nov 2014 13:52:57 GMT",
      "Transfer-Encoding" => "",
           "Content-Type" => "text/html; charset=utf-8",
                   "Vary" => "Cookie",
        "X-Frame-Options" => "SAMEORIGIN",
                    "Via" => "1.1 vegur"
      }
    end


    it 'should log an error if response 400 malformed or invalid json' do
      response_400 = double Excon::Response
      response_400.stub(:status).and_return(400)
      response_400.stub(:body).and_return('ERROR: malformed or invalid json')
      response_400.stub(:headers).and_return(response_headers)
      Excon.should_receive(:put).and_return(response_400)
      Rails.logger.should_receive(:error).with("GovUkApiError: Response status: 400: ERROR: malformed or invalid json")

      client = GovUkApiClient.new(:update, uuid, json)
      expect {
        client.push
      }.to raise_error GovUkApiError, "Response status: 400: ERROR: malformed or invalid json"
    end

   
    it 'should raise an error if unexpected success response body' do
      response_200 = double Excon::Response
      response_200.stub(:status).and_return(200)
      response_200.stub(:body).and_return('Unexpected body')
      response_200.stub(:headers).and_return(response_headers)
      Excon.should_receive(:put).and_return(response_200)
      Rails.logger.should_receive(:error)

      client = GovUkApiClient.new(:update, uuid, json)
      expect {
        client.push
      }.to raise_error GovUkApiError, 'Invalid Response Body: Unexpected body'
    end


  end



end



def testing_endpoint
  config = YAML.load_file("#{Rails.root}/config/gov_uk_api.yml")['test']
  URI(config['endpoint']).host
end
















