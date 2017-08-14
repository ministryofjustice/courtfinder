require 'postcode_validator'

class OfficialPostcode < ActiveRecord::Base

  def self.is_valid_postcode?(postcode)
    validator = PostcodeValidator.new(attributes: [:postcode])
    validator.valid?(postcode)
  end
end
