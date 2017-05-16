module ContactsHelper

  def enforce_label(type, label = 'Other')
    return label if type.blank?
    name = ContactType.find(type).name
    name.blank? ? label : name
  end

  def contact_visible_in_view(contact)
    # This is not a model  scope because print_view depends on the request url
    (print_view && contact.in_leaflet) || !print_view
  end

  def contacts_for_view(contacts, filter = 'only_telephones')
    contacts.select { |contact| contact_visible_in_view(contact) }
    if filter == 'only_telephones'
      contacts.reject { |contact| contact.contact_type.try(:name) == 'DX' }
    elsif filter == 'only_dx_numbers'
      contacts.select { |contact| contact.contact_type.try(:name) == 'DX' }
    end
  end

  def contacts_as_group_for_telephones(contacts, glue = ' or ')
    list = contacts.inject([]) do |contact_list, contact|
      if is_telephone_number_valid?(contact)
        contact_list << make_telephone_number_clickable(contact.telephone)
      end
      contact_list
    end
    safe_join(list, glue)
  end

  def contacts_as_group_for_dx_numbers(contacts, glue = ' or ')
    list = contacts.inject([]) do |contact_list, contact|
      contact_list << contact.telephone unless is_telephone_number_valid?(contact)
      contact_list
    end
    safe_join(list, glue)
  end

  def make_telephone_number_clickable(telephone)
    link_to(telephone, ['tel:', GlobalPhone.normalize(telephone, :gb)].join)
  end

  def is_telephone_number_valid?(contact)
    contact.contact_type.try(:name) != 'DX'
  end

  def show_legal_professional_section?
    (@court.court_number.present? && @court.court_number != 0) ||
      (@court.contacts.present? && @court.contacts.with_dx_numbers.present?)
  end
end
