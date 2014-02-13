module ContactsHelper
  def always_label(type, label='Other')
    if type.nil?
      return label
    else
      name = ContactType.find(type).name
      if name.blank?
        return label
      else
        return name
      end
    end
  end

  def contact_visible_in_this_view(contact)
    (print_view && contact.in_leaflet) || !print_view
  end

  def contacts_in_this_view(contacts)
    contacts.reject do |contact|
      contact_visible_in_this_view(contact) == false
    end
  end

  def display_as_group(contacts, glue=' or ')
    contact_list = []
    
    contacts.each do |contact|
      contact_list << link_to(contact.telephone, ['tel:', GlobalPhone.normalize(contact.telephone, :gb)].join)
    end

    contact_list.join(glue).html_safe
  end
end
