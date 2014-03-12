class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    parsed = Mail::Address.new(value)
    record.errors.add(attribute, "is not valid. Please enter a valid email address.") unless parsed.address == value && parsed.local != value
    if service = check_duplicate_email(record, value)
      record.errors.add(attribute, "is invalid. Email address #{value} is already entered for #{service}.") 
    end
  rescue Mail::Field::ParseError
    record.errors.add(attribute, "is not valid. Please enter a valid email address.")
  end

  private
  def check_duplicate_email(email, address)
    court_emails = email.court.emails
    if i = find_existing_email(court_emails, address)
      court_emails[i].contact_type_name if court_emails[i] != email
    end
  end  

  def find_existing_email(emails, address)
    #Strip whitespace of existing emails and check if new email already exists
    emails.pluck(:address).collect { |e| e.gsub(" ","").downcase }.index(address.gsub(" ","").downcase)
  end
end
