require 'awesome_print'
require 'csv'

namespace :import do

  desc "Import all data"
  task :all, [:replace] => :environment do | t, args |
    puts "Importing eveything!"
    puts "If you're on a Windows computer, now is a good time to make a cup of tea"

    if args.replace == 'replace'
      puts <<-EOF
*******************************************************
REPLACE IS DEPRECATED.
If you want to clear the data, use standard rake tasks,
instead: `rake db:reset` or `rake db:drop db:drop db:migrate`
followed by `rake import:all`.  You can try to chain `import:all`
on to the other rake tasks.  YMMV, however--on my machine, chaing
causes an odd race condition whereby the before_validation hook that
adds the UUID to a Court errors stating that it cannot find the
attribute.
*******************************************************
      EOF
    end

    Rake::Task["import:regions"].invoke
    Rake::Task["import:areas"].invoke
    Rake::Task["import:courts"].invoke
    Rake::Task["import:countries"].invoke
    Rake::Task["import:counties"].invoke
    Rake::Task["import:towns"].invoke
    Rake::Task["import:addresses"].invoke
    Rake::Task["import:areas_of_law"].invoke
    Rake::Task["import:opening_times"].invoke
    Rake::Task["import:contacts"].invoke
    Rake::Task["import:emails"].invoke
    Rake::Task["import:images"].invoke
    Rake::Task["import:court_facilities"].invoke
    Rake::Task["import:postcode_courts"].invoke

    puts ">>> All done, yay!"
  end

  desc "Import courts"
  task :courts => :environment do
    puts "Importing courts and their types"

    CSV.foreach('db/data/court.csv', headers: true) do |row|
      puts "Finding or creating court #{row['court_name']}"
      c = Court.find_or_create_by!(name: row['court_name'])
      puts "Updating attributes for #{row['court_name']}"
      c.update_attributes(
        old_id:                 row['court_id'],
        court_number:           row['court_number'],                                # court_code
        info:                   row['court_note'].gsub(/"'/, '"'),                  # clean-up HTML links which use single quotes, assuming they appear in the data as ""'
        cci_code:               row['court_cci_identifier'],
        area_id:                Area.find_by_old_id(row['court_area_id']).try(:id), # some have more than one
        old_postal_address_id:  row['court_postal_addr_id'],
        old_court_address_id:   row['court_addr_id'],
        old_court_type_id:      row['court_type_id'],
        display:                true
      )
    end
  end

  desc "Import countries"
  task :countries => :environment do
    puts "Importing countries"
    CSV.foreach('db/data/court_country.csv', headers: true) do |row|
      next if row[1].blank?
      puts "Finding or creating country '#{row[1]}'"
      Country.find_or_create_by!(old_id: row[0], name: row[1]) rescue "Could not create country #{row[1]}"
    end
  end

  desc "Import counties"
  task :counties => :environment do
    puts "Importing counties"
    CSV.foreach('db/data/court_county.csv', headers: true) do |row|
      next if row[1].blank?
      puts "Finding or creating county '#{row[1]}'"
      country_id = Country.find_by_old_id(row[2]).try(:id)
      County.find_or_create_by!(old_id: row[0], name: row[1], country_id: country_id) rescue "Could not create county #{row[1]}"
    end
  end

  desc "Import towns"
  task :towns => :environment do
    puts "Importing towns"
    CSV.foreach('db/data/court_town.csv', headers: true) do |row|
      next if row[1].blank?
      puts "Finding or creating town '#{row[1]}'"
      country_id = Country.find_by_old_id(row[2]).try(:id)
      Town.find_or_create_by!(old_id: row[0], name: row[1], country_id: country_id) rescue "Could not create town #{row[1]}"
    end
  end

  desc "Import addresses"
  task :addresses => :environment do
    puts "Importing court address"
    visiting = AddressType.where(name: 'Visiting').first_or_create
    postal = AddressType.where(name: 'Postal').first_or_create

    CSV.foreach('db/data/court_address.csv', headers: true) do |row|
      court_detail = {}
      row.map{ |k, v| court_detail[k.gsub('court_','')] = v.empty? ? nil : v }

      court = (court_detail['addr_postal_flag'] == 'true') ?
        Court.find_by_old_postal_address_id(row[0]) : Court.find_by_old_court_address_id(row[0])

      if court and court_detail['addr1'].present?
        puts "Finding or creating '#{court.name}' - '#{court_detail['addr1']}'"

        Address.find_or_create_by(
          court_id: court.id,
          address_line_1: court_detail['addr1'],
          address_line_2: court_detail['addr2'],
          address_line_3: court_detail['addr3'],
          address_line_4: court_detail['addr4'],
          postcode: court_detail['addr_pcode'],
          dx: court_detail['addr_dx'],
          town_id: Town.find_by_old_id(row[8]).try(:id),
          address_type: (court_detail['addr_postal_flag'] == 'true') ? postal : visiting,
          is_primary: (court_detail['addr_postal_flag'] == 'true')
        )
      end
    end
  end

  desc "Import areas of law"
  task :areas_of_law => :environment do
    CSV.foreach('db/data/court_work_type.csv', headers: true) do |row|
      puts "Finding or creating AreaOfLaw '#{row[1]}'"
      AreaOfLaw.find_or_create_by!(
        old_id:         row[0],
        name:           row[1],
        old_ids_split:  row[2],
        action:         row[3]
      )
    end

    CSV.foreach('db/data/court_work.csv', headers: true) do |row|
      puts "Finding or creating Remit '#{row[1]}'"
      area_of_law = AreaOfLaw.find_by_old_id(row[1])
      court       = Court.find_by_old_id(row[2])
      next if area_of_law.blank? || court.blank?

      Remit.find_or_create_by!(
        area_of_law_id: area_of_law.id,
        court_id:       court.id
      )
    end
  end

  desc "Import opening types and opening times"
  task :opening_times => :environment do
    puts "Importing opening types and opening times"
    CSV.foreach('db/data/court_opening_type.csv', headers: true) do |row|
      puts "Finding or creating OpeningType '#{row[1]}'"
      OpeningType.find_or_create_by!(
        old_id:         row[0],
        name:           row[1]
      )
    end

    CSV.foreach('db/data/court_opening.csv', headers: true) do |row|
      sort_order = 0
      court = Court.find_by_old_id(row[1])
      type  = OpeningType.find_by_old_id(row[3])
      next unless court && type
      puts "Finding or created Opening Time '#{row[2]}' for #{court.name}"
      # "court_opening_id","court_id","court_opening_desc","court_opening_type_id"

      OpeningTime.find_or_create_by!(
        court_id: court.id,
        name:     row[2],
        sort:     sort_order, # default to the order which they are imported
        opening_type_id: type.id
      )

      sort_order += 1
    end
  end

  desc "Import contact types and contacts"
  task :contacts => :environment do
    puts "Importing contact types"
    CSV.foreach('db/data/court_contact_type.csv', headers: true) do |row|
      puts "Finding or creating ContactType '#{row[1]}'"
      ContactType.find_or_create_by!(
        old_id:         row[0],
        name:           row[1])
    end

    puts "Importing contacts"

    puts "General Contacts"
    CSV.foreach('db/data/court_contacts_general.csv', headers: true) do |row|
      puts "Finding or creating general Contact '#{row['court_contacts_general_no']}'"
      court = Court.find_by_old_id(row['court_id'])
      type  = ContactType.find_by_old_id(row[3])
      number = GlobalPhone.parse(row['court_contacts_general_no'], :gb).national_format rescue row['court_cotnacts_general_number']
      next unless court && number
      Contact.find_or_create_by!(
        court_id:      court.id,
        telephone:     number,
        in_leaflet:    true,
        contact_type:  type,
        sort:          row['court_contact_general_order'].to_i) rescue "Cannot find or create contact for #{row['court_contact_general_no']}"
    end

    puts "Named Contacts"
    CSV.foreach('db/data/court_contacts.csv', headers: true) do |row|
      puts "Finding or creating named Contact '#{row['court_contacts_name']}'"
      court = Court.find_by_old_id(row['court_id'])
      type  = ContactType.find_by_old_id(row['court_contact_type_id'])
      next unless court

      Contact.find_or_create_by!(
        court_id:      court.id,
        telephone:     row['court_contacts_no'],
        in_leaflet:    true,
        contact_type:  type,
        sort:          row['court_contacts_order'].to_i + 1000) rescue "Cannot find or create contact for #{row['court_contacts_name']}"
    end
  end

  desc "Import emails"
  task :emails => :environment do
    puts "Importing emails"
    CSV.foreach('db/data/court_email.csv', headers: true) do |row|
      puts "Finding or creating email '#{row['court_email_addr']}'"
      court = Court.find_by_old_id(row['court_id'])
      addr  = row['court_email_addr'].strip
      next unless court && addr
      Email.find_or_create_by(
        court_id:    court.id,
        address:     addr,
      )
    end
  end

  desc "Import images"
  task :images => :environment do
    puts "Importing images"

    # First add the old image IDs to the courts
    CSV.foreach('db/data/court_images.csv', headers: true) do |row|
      court = Court.find_by_old_id(row['court_id'])
      next unless court
      puts "Adding image id #{row['image_id']} to #{court.name}"
      court.update_column(:old_image_id, row['image_id'].to_i)
    end

    # "image_id","image_desc","image_url","image_icon_flag"
    CSV.foreach('db/data/images.csv', headers: true) do |row|
      if row['image_icon_flag'] == 'true'
      puts "Finding or creating Facility for image #{row['image_url']}"
        Facility.find_or_create_by!(
          old_id: row['image_id'],
          name: row['image_desc'].split(' icon')[0], # strip "icon." off the end
          image_description: row['image_desc'],
          image: row['image_url'].split('.')[0] # strip ".gif" off the end
        )
      else
        # Multiple courts have no image available (id = 21)
        Court.where(:old_image_id => row['image_id']).each do |court|
          puts "Updating court #{court.name} with image #{row['image_url']}"
          court.update_attributes(
            image_description: row['image_desc'],
            image: row['image_url']
          )
        end
      end
    end
  end

  desc "Import court facilities"
  task :court_facilities => :environment do
    puts "Importing court facilities"

    # "court_access_id","image_id","court_access_desc","court_id"
    CSV.foreach('db/data/court_access.csv', headers: true) do |row|
      court    = Court.find_by_old_id(row['court_id'])
      facility = Facility.find_by_old_id(row['old_id'])

      next unless court
      puts "Find or create CourtFacility #{row['image_id']} for #{court.name}"
      desc = Nokogiri::HTML(row['court_access_desc'].strip).inner_text if row['court_access_desc'].present?

      CourtFacility.find_or_create_by!(
        court_id:     court.id,
        facility:     facility,
        description:  desc
      )
    end
  end

  desc "Import regions"
  task :regions => :environment do
    puts "Importing regions"
    CSV.foreach('db/data/court_region.csv', headers: true) do |row|
      next if row[1].blank?
      puts "Finding or creating region '#{row[1]}'"
      Region.find_or_create_by!(old_id: row[0], name: row[1]) rescue "Could not create region #{row[1]}"
    end
  end

  desc "Import areas"
  task :areas => :environment do
    puts "Importing areas"
    CSV.foreach('db/data/court_area.csv', headers: true) do |row|
      next if row[1].blank?
      puts "Finding or creating area '#{row[1]}'"
      region_id = Region.find_by_old_id(row[2]).try(:id)
      Area.find_or_create_by!(old_id: row[0], name: row[1], region_id: region_id) rescue "Could not create area #{row[1]}"
    end
  end

  desc "Import postcode to court mappings"
  task :postcode_courts => :environment do
    JSON.load(File.read(Rails.root.join('db','data','postcodes_courts.json'))).each do |court_postcodes|
      court = Court.find_by_name(court_postcodes['name'])
      next unless court

      court_postcodes['postcodes'].each do |postcode|
        puts "Find or create postcode '#{postcode}' for court '#{court.name}'"
        PostcodeCourt.find_or_create_by(court_id: court.id, postcode: postcode)
      end
    end
  end

  desc "Import local_authorities for a single area of law"
  task :local_authorities_for_area_of_law, [:file, :area_of_law] => :environment do |t, args|
    puts "Importing local authorities for each court"
    puts "File: #{args[:file]}, Area of Law: #{args[:area_of_law]}"

    csv_file = File.read(args[:file])

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    # "court_name", "local_authority_names"
    @area_of_law = AreaOfLaw.find_by_name(args[:area_of_law])
    puts "Found: #{@area_of_law.name} with id: #{@area_of_law.try(:id)}"

    csv.each do |row|
      court = Court.find_by_name(row[0])

      if court.nil?
        puts "Could not find court with name: '#{row[0]}'"
      else
        puts "Adding local authorities(LA) for '#{court.name}'"
        row[1].split(',').each do |local_authority_name|
          local_authority = LocalAuthority.find_by_name(local_authority_name)
          if local_authority.nil?
            puts "Could not find local authority '#{local_authority_name}' for court '#{court.name}'"
          else
            puts "Adding LA with named '#{local_authority_name}'"
            court.remits.where(area_of_law_id: @area_of_law.id).first_or_create!.local_authorities << local_authority
          end
        end
      end
    end
  end

  desc "Import local_authorities for a all areas of law"
  task :local_authorities => :environment do
    Rake::Task["import:local_authorities_for_area_of_law"].invoke('db/data/local_authorities_for_children.csv', 'Children')
    Rake::Task["import:local_authorities_for_area_of_law"].reenable
    Rake::Task["import:local_authorities_for_area_of_law"].invoke('db/data/local_authorities_for_divorce.csv',  'Divorce')
    Rake::Task["import:local_authorities_for_area_of_law"].reenable
    Rake::Task["import:local_authorities_for_area_of_law"].invoke('db/data/local_authorities_for_adoption.csv', 'Adoption')
  end

  desc "Import concil names"
  task :local_authorities => :environment do
    puts "Importing local authorities"

    # "authority_id","authority_name"
    csv_file = File.read('db/data/local_authorities.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      puts "Adding local authority: #{row[1]}"

      local_authority = LocalAuthority.new

      local_authority.name = row[1]

      counter += 1 if local_authority.save!
    end

    puts ">>> #{counter} of #{csv.length} local authorities added"

  end

end
