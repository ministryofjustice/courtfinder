require 'json'
require 'fog'

class CourtsJsonExporter
  def export!
    json = build_courts_json

    fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'eu-west-1'
    }

    connection = Fog::Storage.new(fog_credentials)
    s3 = connection.directories.get(ENV['APP_S3_BUCKET'])
    s3.files.create(key: 'courts.json', body: json)
  end

  def build_courts_json
    JSON.pretty_generate(build_courts, indent: '    ')
  end

  def build_courts
    courts.inject([]) do |collection, court|
      court_hash                    = {}
      court_hash['addresses']       = build_addresses(court)
      court_hash['updated_at']      = court.updated_at_before_type_cast if court.updated_at.present?
      court_hash['admin_id']        = court.id
      court_hash['facilities']      = build_facilities(court)
      court_hash['lat']             = court.latitude.to_s if court.latitude.present?
      court_hash['cci_code']        = court.cci_code if court.cci_code.present?
      court_hash['slug']            = court.slug
      court_hash['opening_times']   = build_opening_times(court) if build_opening_times(court)
      court_hash['court_types']     = build_court_types(court)
      court_hash['name']            = court.name
      court_hash['contacts']        = build_contacts(court)
      court_hash['created_at']      = court.created_at_before_type_cast if court.created_at.present?
      court_hash['court_number']    = court.court_number
      court_hash['lon']             = court.longitude.to_s if court.longitude.present?
      court_hash['postcodes']       = build_postcodes(court)
      court_hash['emails']          = build_emails(court) || []
      court_hash['areas_of_law']    = build_areas_of_law(court)
      court_hash['display']         = court.display
      court_hash['image_file']      = court.image_file if court.image_file.present?
      court_hash['alert']           = court.alert if court.alert.present?
      court_hash['parking']         = build_parking(court) if build_parking(court).any?
      court_hash['directions']      = court.directions if court.directions.present?

      collection << court_hash
    end
  end

  private

  def build_parking(court)
    parking = {}
    parking['onsite'] =  I18n.t(court.parking_onsite) if court.parking_onsite.present?
    parking['offsite'] =  I18n.t(court.parking_offsite) if court.parking_offsite.present?
    parking['blue_badge'] =  I18n.t(court.parking_blue_badge) if court.parking_blue_badge.present?
    parking
  end

  def build_areas_of_law(court)
    court.areas_of_law.unscope(:order).order(id: :asc).inject([]) do |collection, area_of_law|
      area_of_law_hash = {}
      area_of_law_hash['name'] = area_of_law.name
      area_of_law_hash['slug'] = area_of_law.slug

      remit = Remit.find_by(court_id: court.id, area_of_law_id: area_of_law.id)
      area_of_law_hash['single_point_of_entry'] = remit.single_point_of_entry if remit && remit.single_point_of_entry.present?

      local_authorities = court.area_local_authorities_list(area_of_law)
      local_authorities = [] if local_authorities.blank?
      area_of_law_hash['local_authorities'] = local_authorities.sort

      collection << area_of_law_hash
    end
  end

  def build_addresses(court)
    court.addresses.inject([]) do |collection, address|
      collection << {
        'town'      => address.town.name,
        'county'    => address.town.county.name,
        'type'      => address.address_type.name,
        'postcode'  => address.postcode,
        'address'   => address.lines.join("\n")
      }
    end
  end

  def build_court_types(court)
    court.court_types.inject([]) do |collection, court_type|
      collection << court_type.name
    end
  end

  def build_contacts(court)
    court.contacts.unscope(:order).inject([]) do |collection, contact|
      collection << {
        'sort'    => contact.sort,
        'name'    => contact.contact_type.name,
        'number'  => contact.telephone
      }
    end
  end

  def build_emails(court)
    court.emails.unscope(:order).inject([]) do |collection, email|
      if email.contact_type
        collection << {
          'description' => email.contact_type.name,
          'address'     => email.address
        }
      end
    end
  end

  def build_facilities(court)
    court.court_facilities.unscope(:order).inject([]) do |collection, court_facility|
      collection << {
        'image_description'   => court_facility.facility.image_description,
        'image'               => court_facility.facility.image,
        'description'         => court_facility.description,
        'name'                => court_facility.facility.name
      }
    end
  end

  def build_postcodes(court)
    court.postcode_courts.inject([]) do |collection, postcode_court|
      collection << postcode_court.postcode
    end
  end

  def build_opening_times(court)
    court.opening_times.unscope(:order).inject([]) do |collection, opening_time|
      collection << "#{opening_time.opening_type.name}: #{opening_time.name}"
    end
  end

  def courts
    Court.includes(
      :court_types_courts,
      :court_types,
      :remits,
      :postcode_courts,
      area: :region,
      opening_times: :opening_type,
      areas_of_law: :remits,
      court_facilities: :facility,
      emails: :contact_type,
      contacts: :contact_type,
      addresses: [:address_type, town: :county]
    )
  end
end
