module AddressesHelper
  def format_address(addr)
    ("<p itemscope itemtype='http://schema.org/PostalAddress' itemprop='address'>
       <span itemprop='streetAddress'>#{addr.addressLines('<br />')}</span><br/>" +
      (addr.town.name ? "<span itemprop='addressLocality'>#{addr.town.name}</span><br/>" : '') +
       "<span itemprop='county'>#{addr.town.county.name}</span><br/>
       <span itemprop='postalCode'>#{addr.postcode}</span><br/>
       #{addr.dx}
     </p>").html_safe
  end
end
