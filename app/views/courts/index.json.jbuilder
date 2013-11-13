if params[:compact]

  json.array! @courts.visible.collect { |court| [court.name,court.slug] }

else

  json.set! "@context" do 
    json.set! "@vocab", 'http://schema.org/'
    json.geo 'http://www.w3.org/2003/01/geo/wgs84_pos#'
  end
  
  
  json.courts do
  
    json.array! @courts.visible do |court|
      
      json.set! "@id", [request.original_url, court.slug].join('/') if court.slug?
      
      json.image court.image_file_url if court.image_file_url
      json.name court.name if court.name?
      
      json.description court.info if court.info?
      
      json.set! "@type", [ "Courthouse" ]
      json.set! "geo:latitude", court.latitude if court.latitude?
      json.set! "geo:longitude", court.longitude if court.longitude?
      
      addresses = court.addresses
      if address = (addresses.postal.first || addresses.visiting.first)
        json.set! :address do
          json.set! "@type", 'PostalAddress'
          json.postalCode address.postcode if address.postcode?
          json.addressRegion address.town.county.name if address.town.county.name?
          json.town address.town.name if address.town.name?
          street_address = []
          street_address.push address.address_line_1 if address.address_line_1?
          street_address.push address.address_line_2 if address.address_line_2?
          street_address.push address.address_line_3 if address.address_line_3?
          street_address.push address.address_line_4 if address.address_line_4?
          street_address.push address.dx if address.dx?
          json.streetAddress street_address.join(', ')
        end
      end
      
      telephone_contacts = court.contacts.inject([]) do | acc, contact |
        acc.push [contact.name, contact.telephone].join(': ')
      end
      json.telephone telephone_contacts if telephone_contacts.any?
      
      contact_points = court.emails.inject([]) do | acc, email |
        acc.push({:contactType => email.description, :email => email.address, :@type => "ContactPoint"})
      end
      
      json.contactPoint contact_points if contact_points.any?
    end
  end
end  
  
