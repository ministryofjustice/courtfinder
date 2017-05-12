module AddressesHelper
  def format_address(addr)
    return if addr.blank?
    add = []
    add << content_tag(:span, address_lines(addr), property: 'address', typeof: 'http://schema.org/PostalAddress')
    if addr.town
      add << town_name(addr)
      add << region(addr)
    end
    add << postcode(addr)

    content_tag :p, safe_join(add), property: 'address', typeof: 'http://schema.org/PostalAddress'
  end

  private

  def town_name(addr)
    return if addr.town.name.blank?
    safe_join([content_tag(:span, addr.town.name, property: 'addressLocality'),
               content_tag(:br)])
  end

  def region(addr)
    return if addr.town.county.blank? || addr.town.county.name.blank?
    safe_join([content_tag(:span, addr.town.county.name, property: 'addressRegion'),
               content_tag(:br)])
  end

  def postcode(addr)
    return if addr.postcode.blank?
    safe_join([content_tag(:span, addr.postcode, property: 'postalCode'),
               content_tag(:br)])
  end

  def address_lines(addr)
    lines = addr.lines.map do |line|
      content_tag :br, line
    end
    safe_join(lines)
  end
end
