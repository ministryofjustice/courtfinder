class ContactValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if check_phone_format(value).nil?
      record.errors.add(attribute, "is invalid. Please enter a phone number, only digits and spaces allowed.") 
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

  def check_phone_format(phone_number)
    phone_number =~ /^(?=.*\d)(?:[\d ]+)$/
  end
end
