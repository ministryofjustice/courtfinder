require 'spec_helper'
require File.dirname(__FILE__) + '/../mocks/mock_gov_uk_json.rb'

describe JsonSchemaValidator do

  let(:expected_hash)  { MockGovUkJson.expected_hash }

  it 'should return true for a valid hash' do
    v = JsonSchemaValidator.new(expected_hash)
    expect(v.validate).to be true
  end

  it 'should return errors if there are things wrong' do
    invalid_hash = expected_hash
    invalid_hash.delete('slug')
    invalid_hash['court_number'] = 4554
    invalid_hash['lat'] = '51.7878787'
    v = JsonSchemaValidator.new(invalid_hash.as_json)
    expect(v.validate).to be false
    expect(v.num_errors).to eq 3
    expect(v.errors[0]).to eq "The property '#/' did not contain a required property of 'slug' in schema"
    expect(v.errors[1]).to eq "The property '#/lat' of type String did not match the following type: number in schema"
    expect(v.errors[2]).to eq "The property '#/court_number' of type Fixnum did not match the following type: string in schema"
  end
end





