json.set! "@context" do 
  json.set! "@vocab", 'http://schema.org/'
  json.geo 'http://www.w3.org/2003/01/geo/wgs84_pos#' if @court.latitude? or @court.longitude?
end

json.set! "@id", [request.original_url, @court.slug].join('/') if @court.slug?

json.image @court.image_file_url if @court.image_file_url
json.name @court.name if @court.name?

json.description @court.info if @court.info?

json.set! "@type", [ "GovernmentOrganization", "Courthouse" ]
json.set! "geo:latitude", @court.latitude if @court.latitude?
json.set! "geo:longitude", @court.longitude if @court.longitude?

if @court.addresses.primary
  visiting = @court.addresses.primary
  json.set! :address do
    json.set! "@type", 'PostalAddress'
    json.postalCode visiting.postcode if visiting.postcode?
    json.addressRegion visiting.town.county.name if visiting.town.county.name?
    json.town visiting.town.name if visiting.town.name?
    street_address = []
    street_address.push visiting.address_line_1 if visiting.address_line_1?
    street_address.push visiting.address_line_2 if visiting.address_line_2?
    street_address.push visiting.address_line_3 if visiting.address_line_3?
    street_address.push visiting.address_line_4 if visiting.address_line_4?
    street_address.push visiting.dx if visiting.dx?
    json.streetAddress street_address.join(', ')
  end
end

telephone_contacts = @court.contacts.inject([]) do | acc, contact |
  acc.push [contact.name, contact.telephone].join(': ')
end
json.telephone telephone_contacts if telephone_contacts.any?

contact_points = @court.emails.inject([]) do | acc, email |
  acc.push({:contactType => email.description, :email => email.address, :@type => "ContactPoint"})
end

json.contactPoint contact_points if contact_points.any?
