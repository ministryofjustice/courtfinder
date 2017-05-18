class EmailValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    @record = record
    @attribute = attribute
    @value = value

    check_for_missing_value
    check_for_duplication
  rescue Mail::Field::ParseError
    record.errors.add(attribute, "is not valid. Please enter a valid email address.")
  end

  private

  def check_duplicate_email(email, address)
    court_emails = email.court.emails
    i = find_existing_email(court_emails, address)
    return unless i

    court_emails[i].contact_type_name if court_emails[i] != email
  end

  def find_existing_email(emails, address)
    # Strip whitespace of existing emails and check if new email already exists
    emails.pluck(:address).collect { |e| e.delete(" ").downcase }.
      index(address.delete(" ").downcase)
  end

  def check_for_missing_value
    parsed = Mail::Address.new(@value)
    unless parsed.address == @value && parsed.local != @value
      message = "is not valid. Please enter a valid email address."
      @record.errors.add(@attribute, message)
    end
  end

  def check_for_duplication
    service = check_duplicate_email(@record, @value)
    if service
      message = "is invalid. Email address #{@value} is already entered for #{service}."
      @record.errors.add(@attribute, message)
    end
  end
end
