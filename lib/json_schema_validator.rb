require 'json-schema'



# sample json schema validator that uses the 'jschema' gem

class JsonSchemaValidator

  attr_reader :errors

  def initialize(json)
    @json = json
    @schema = File.open("#{Rails.root}/config/gov_uk_json_schema.json", "r") do | fp |
      fp.read
    end
    @errors = nil
  end
  
  def validate
    results = JSON::Validator.fully_validate(@schema, @json)
    @errors = results.map{ |r| r.sub(/\s[0-9a-f-]+\#$/, '') }
    @errors.empty?
  end


  def num_errors
    @errors.size
  end


end




