class ContactValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if is_valid_phone_format(value) == false
      record.errors.add(attribute, "is invalid. Please enter one phone number per entry. \"#{value}\" is not a valid phone number. Please enter a valid phone number, only digits and spaces allowed, up to 12 numbers.") 
    elsif service = check_duplicate_number(record, value)
      record.errors.add(attribute, "is invalid. Phone number #{value} is already entered for #{service}.") 
    end
  end

  private
  def check_duplicate_number(contact, phone_number)
    court_contacts = contact.court.contacts
    if i = find_number_in_existing_contacts(court_contacts, phone_number)
      court_contacts[i].contact_type_name if court_contacts[i] != contact
    end
  end

  def find_number_in_existing_contacts(contacts, number)
    #Strip whitespace of existing contact numbers and check if new number already exists
    contacts.pluck(:telephone).collect { |t| t.gsub(" ","") }.index(number.gsub(" ",""))
  end

  def is_valid_phone_format(phone_number)
    more_than_13_digits = (phone_number.gsub(/[^\d]+/, '').size >= 13)
    has_invalid_chars = !(phone_number =~ /[^\d ]+/).nil?

    !more_than_13_digits && !has_invalid_chars
  end
end
