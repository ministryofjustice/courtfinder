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
      contact_list << link_to(contact.telephone, ['tel:', GlobalPhone.normalize(contact.telephone, :gb)].join)
    end

    contact_list.join(glue).html_safe
  end
end
