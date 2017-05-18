class ContactValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if is_dx_number?(record)
    service = check_duplicate_number(record, value)
    if is_valid_phone_format(value) == false
      message = I18n.t('errors.contact_validator.invalid_phone_format', value: value)
      record.errors.add(attribute, message)
    elsif service
      message = I18n.t('errors.contact_validator.phone_entered', value: value, service: service)
      record.errors.add(attribute, message)
    end
  end

  private

  def check_duplicate_number(contact, phone_number)
    court_contacts = contact.court.contacts
    i = find_number_in_existing_contacts(court_contacts, phone_number)
    if i && court_contacts[i] != contact
      court_contacts[i].contact_type_name
    end
  end

  def find_number_in_existing_contacts(contacts, number)
    # Strip whitespace of existing contact numbers and check if new number already exists
    contacts.pluck(:telephone).collect { |t| t.delete(" ") }.index(number.delete(" "))
  end

  def is_valid_phone_format(phone_number)
    more_than_13_digits = (phone_number.gsub(/[^\d]+/, '').size >= 13)
    has_invalid_chars = !(phone_number =~ /[^\d ]+/).nil?

    !more_than_13_digits && !has_invalid_chars
  end

  def is_dx_number?(record)
    record.contact_type.try(:name) == 'DX'
  end
end
