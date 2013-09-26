module AddressesHelper
  def format_address(addr)
    add = "<p property='address' typeof='http://schema.org/PostalAddress'>"
    add << "<span property='streetAddress'>#{addr.address_lines('<br />')}</span><br/>"
    add << "<span property='addressLocality'>#{addr.town.name}</span><br/>" if addr.town.name.present?
    add << "<span property='addressRegion'>#{addr.town.county.name}</span><br/>" if (addr.town.county.present? && addr.town.county.name.present?)
    add << "<span property='postalCode'>#{addr.postcode}</span><br/>#{addr.dx}</p>" if addr.postcode.present?

    add.html_safe
  end
end
