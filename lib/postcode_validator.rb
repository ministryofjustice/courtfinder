class PostcodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    @record = record
    @attribute = attribute
    @value = value
    @uk_parser = UKPostcode.parse(@value)

    validate_poscode_format
    check_if_postcode_exists
  end

  private

  def validate_poscode_format
    unless @uk_parser.valid?
      message = "is not valid. Please enter a valid postcode."
      @record.errors.add(@attribute, message)
    end
  end

  def check_if_postcode_exists
    return if @record.errors.present?

    if find_postcode.blank?
      message = "is not valid. Please enter a valid postcode."
      @record.errors.add(@attribute, message)
    end
  end

  def find_postcode
    postcode = UKPostcode.parse(@value).to_s

    if @uk_parser.full?
      OfficialPostcode.find_by(postcode: postcode)
    elsif @uk_parser.sector
      OfficialPostcode.find_by(sector: postcode)
    elsif @uk_parser.district
      OfficialPostcode.find_by(district: postcode)
    elsif @uk_parser.area
      OfficialPostcode.find_by(area: postcode)
    end
  end
end
