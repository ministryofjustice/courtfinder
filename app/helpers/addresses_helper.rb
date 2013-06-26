module AddressesHelper
  def format_address(addr)
    ("<p property='address' typeof='http://schema.org/PostalAddress'>
       <span property='streetAddress'>#{addr.address_lines('<br />')}</span><br/>" +
      (addr.town.name ? "<span property='addressLocality'>#{addr.town.name}</span><br/>" : '') +
       "<span property='addressRegion'>#{addr.town.county.name}</span><br/>
       <span property='postalCode'>#{addr.postcode}</span><br/>
       #{addr.dx}
     </p>").html_safe
  end
end
