module ContactsHelper
  def enforce_label(type, label='Other')
    if type
      name = ContactType.find(type).name
      name.blank? ? label : name
    else
      label
    end
  end

  def contact_visible_in_view(contact)
    #This is not a model  scope because print_view depends on the request url
    (print_view && contact.in_leaflet) || !print_view
  end

  def contacts_for_view(contacts)
    contacts.reject { |contact| !contact_visible_in_view(contact) }
  end

  def contacts_as_group(contacts, glue=' or ')
    contact_list = []

    contacts.each do |contact|

      contact_number = if is_telephone_number_valid?(contact)
        make_telephone_number_clickable(contact.telephone)
      else
        contact.telephone
      end

      contact_list << contact_number
    end

    contact_list.join(glue).html_safe
  end

  def make_telephone_number_clickable(telephone)
    link_to(telephone, ['tel:', GlobalPhone.normalize(telephone, :gb)].join)
  end


  def is_telephone_number_valid?(contact)
    contact.contact_type.try(:name) != 'DX'
  end
end
