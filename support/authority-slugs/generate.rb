require 'ostruct'
require 'net/http'
require 'json'
require 'byebug'

class AuthoritySlugGenerator < OpenStruct
  def mapit_url
    @mapit_url || 'http://ec2-54-72-85-21.eu-west-1.compute.amazonaws.com/'
  end

  def authority_types
    @authority_types || ['UTA','LBO','MTD', 'CTY', 'DIS', 'LGD']
    # MTD -> Metropolitan District
    # LBO -> London Borough
    # UTA -> Unitary Authorities
    # CTY -> Council Areas (Scotland?)
  end

  def fetch_slugs
    authorities = fetch_authorities
    slugs = authorities.values.map {|authority|
      [ slug_for_authority_name(authority["name"]), { "name" => authority["name"], "ons" => authority["codes"]["ons"], "gss" => authority["codes"]["gss"], "country" => authority["country"] } ]
    }
    Hash[slugs]
  end

  def fetch_authorities
    json = Net::HTTP.get( URI.parse( mapit_url + 'areas/' + authority_types.join(',') ))
    authorities = JSON::parse(json)
    a = authorities.reject do |k,v|
      v["country_name"]=='Scotland'
    end
    a.each { |k,v| puts v["country_name"] }
  end

  def slug_for_authority_name(name)
    return fixed_authority_slugs[name] unless fixed_authority_slugs[name].nil?

    normalized_name = name.sub(/(District|County|Borough|City)? (Council|Corporation)?$/i, '')
    normalized_name.sub!(/^(Comhairle nan|City of)/, '') unless normalized_name =~ /City of London/
    normalized_name.strip.downcase.gsub(/[^A-Za-z0-9\-\s]/,'').gsub(/\s+/, '-')
  end

  def fixed_authority_slugs
    {
      "Durham County Council" => "county-durham",
      "Hull City Council" => "kingston-upon-hull",
      "Rhondda Cynon Taf Council" => "rhondda-cynon-taff"
    }
  end
end

slugs = AuthoritySlugGenerator.new.fetch_slugs
json = JSON.pretty_generate(slugs)

File.open('authorities.json', 'w') do |f|
  f.write(json)
end
