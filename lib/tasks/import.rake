require 'awesome_print'

namespace :import do

  require 'csv'

  desc "Import courts"
  task :courts => :environment do
    puts "Importing courts and their types"

    csv_file = File.read('db/data/court.csv')

    # "court_id","court_name","court_code","court_note","court_area_id","court_cci_identifier","court_cci_code","court_addr_id","court_postal_addr_id","court_type_id","borough_search_id","court_code2"
    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      court = Court.new

      puts "#{row[1]} #{row[2]}"

      court.old_id = row[0]
      court.name = row[1]
      court.court_number = row[2]                     # court_code
      court.info = row[3].gsub(/"'/, '"')             # clean-up HTML links which use single quotes, assuming they appear in the data as ""'
      court.cci_code = row[6]
      court.area_id = Area.find_by_old_id(row[4]).id  # some have more than one
      court.old_postal_address_id = row[8]
      court.old_court_address_id = row[7]
      court.old_court_type_id = row[9]
      court.display = true

      court.save!

      counter += 1
    end

    puts ">>> #{counter} of #{csv.length} courts added"

  end

  desc "Import all data"
  task :all, [:replace] => :environment do | t, args |
    puts "Importing eveything!"
    puts "Note: This will ADD all data. To replace all data, use:\n  rake 'import:all_data[replace]'"
    puts "If you're on a Windows computer, now is a good time to make a cup of tea"

    if args.replace == 'replace'
      puts "!!! Removing all court data from your database"
      Region.destroy_all
      Area.destroy_all
      Court.destroy_all
      AddressType.destroy_all
      Country.destroy_all
      County.destroy_all
      Town.destroy_all
      Address.destroy_all
      AreaOfLaw.destroy_all
      OpeningType.destroy_all
      OpeningTime.destroy_all
      ContactType.destroy_all
      Contact.destroy_all
      Email.destroy_all
      Facility.destroy_all
      CourtFacility.destroy_all
    end

    Rake::Task["import:regions"].invoke
    Rake::Task["import:areas"].invoke
    Rake::Task["import:courts"].invoke
    Rake::Task["import:address_types"].invoke
    Rake::Task["import:countries"].invoke
    Rake::Task["import:counties"].invoke
    Rake::Task["import:towns"].invoke
    Rake::Task["import:addresses"].invoke
    Rake::Task["import:areas_of_law"].invoke
    Rake::Task["import:opening_times"].invoke
    Rake::Task["import:contact_types"].invoke
    Rake::Task["import:contacts"].invoke
    Rake::Task["import:emails"].invoke
    Rake::Task["import:images"].invoke
    Rake::Task["import:court_facilities"].invoke

    puts ">>> All done, yay!"
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

        Address.find_or_create_by!(
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


  desc "Import court types"
  task :court_types => :environment do
    puts "Deleting existing Court types records"
    CourtType.destroy_all

    puts "Creating court types"

    puts "Adding 'County Court'"
    CourtType.create!(:name => "County Court")
    puts "Adding 'Magistrates Court'"
    CourtType.create!(:name => "Magistrates Court")
    puts "Adding 'Crown Court'"
    CourtType.create!(:name => "Crown Court")
    puts "Adding 'Tribunal'"
    CourtType.create!(:name => "Tribunal")
  end

  desc "Import areas of law"
  task :areas_of_law => :environment do
    puts "Importing areas of law"

    csv_file = File.read('db/data/court_work_type.csv')

    csv = CSV.parse(csv_file, :headers => true)

    csv.each do |row|
      area = AreaOfLaw.new

      puts "Adding '#{row[1]}'"

      area.old_id = row[0]
      area.name = row[1]
      area.old_ids_split = row[2]
      area.action = row[3]

      area.save!
    end

    csv_file = File.read('db/data/court_work.csv')

    csv = CSV.parse(csv_file, :headers => true)

    csv.each do |row|
      area = Remit.new

      puts "Adding '#{row[1]}'"

      area.area_of_law_id = AreaOfLaw.find_by_old_id(row[1]).id
      area.court_id = Court.find_by_old_id(row[2]).id

      area.save!
    end

  end

  desc "Import opening types and opening times"
  task :opening_times => :environment do
    puts "Importing opening types and opening times"

    csv_file = File.read('db/data/court_opening_type.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      type = OpeningType.new

      puts "Adding '#{row[1]}'"
      # "court_opening_type_id","court_opening_type_desc"

      type.old_id = row[0]
      type.name = row[1]

      counter += 1 if type.save!
    end

    puts ">>> #{counter} of #{csv.length} opening types added"

    csv_file = File.read('db/data/court_opening.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      time = OpeningTime.new

      court = Court.find_by_old_id(row[1])

      puts "Adding '#{row[2]}' to #{court.name}"
      # "court_opening_id","court_id","court_opening_desc","court_opening_type_id"

      if court
        time.court_id = court.id
        time.name = row[2]
        time.sort = counter # default to the order which they are imported

        type = OpeningType.find_by_old_id(row[3])
        time.opening_type_id = type.id if type

        counter += 1 if time.save!
      end

    end

    puts ">>> #{counter} of #{csv.length} opening types added"

  end

  desc "Import contact types"
  task :contact_types => :environment do
    puts "Importing contact types"

    csv_file = File.read('db/data/court_contact_type.csv')

    csv = CSV.parse(csv_file, :headers => true)

    csv.each do |row|
      type = ContactType.new

      puts "Adding '#{row[1]}'"
      # "court_contact_type_id","court_contact_type_desc"

      type.old_id = row[0]
      type.name = row[1]

      type.save!
    end

  end

  desc "Import contacts"
  task :contacts => :environment do
    puts "Importing contacts"

    # First add General Contacts

    csv_file = File.read('db/data/court_contacts_general.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      court = Court.find_by_old_id(row[2])

      if court
        contact = Contact.new

        puts "Adding '#{row[1]}'"
        # "court_contacts_general_id","court_contacts_general_no","court_id","court_contact_type_id","court_contact_general_order"

        contact.telephone = row[1]
        if number = GlobalPhone.parse(contact.telephone, :gb)
          contact.telephone = number.national_format
        end
        contact.court_id = court.id
        contact.in_leaflet = true

        type = ContactType.find_by_old_id(row[3])
        contact.contact_type_id = type.id if type

        contact.sort = row[4].to_i

        counter += 1 if contact.save!(validate: false)
      end
    end

    puts ">>> #{counter} of #{csv.length} general contacts added"

    # Now add Contacts to same table

    csv_file = File.read('db/data/court_contacts.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      court = Court.find_by_old_id(row[3])

      if court
        contact = Contact.new

        puts "Adding '#{row[1]}'"

        contact.telephone = row[2] if row[1] != 'NULL'
        contact.court_id = court.id
        contact.in_leaflet = false

        type = ContactType.find_by_old_id(row[4])
        contact.contact_type_id = type.id if type

        contact.sort = row[5].to_i + 1000 # added 1000 to make sure contacts appear after general contacts

        counter += 1 if contact.save!(validate: false)
      end
    end

    puts ">>> #{counter} of #{csv.length} contacts added"

  end

  desc "Import emails"
  task :emails => :environment do
    puts "Importing emails"

    csv_file = File.read('db/data/court_email.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      court = Court.find_by_old_id(row[3])

      if court
        email = Email.new

        # "court_email_id","court_email_desc","court_email_addr","court_id"
        addr = row[2].strip
        puts "Adding '#{addr}'"

        email.address = addr if row[2].present?
        email.court_id = court.id

        counter += 1 if email.save!(validate: false)
      end
    end

    puts ">>> #{counter} of #{csv.length} emails addresses added"

  end

  desc "Import images"
  task :images => :environment do
    puts "Importing images"

    # First add the old image IDs to the courts

    csv_file = File.read('db/data/court_images.csv')

    # "court_images_id","image_id","court_id"
    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      court = Court.find_by_old_id(row[2])

      if court
        puts "Adding image id #{row[1]} to #{court.name}"

        court.old_image_id = row[1]

        counter += 1 if court.save!(validate: false)
      end

    end

    puts ">>> #{counter} of #{csv.length} image ids added"

    # Now add the images
    # For this we are dropping the old 'images' table and adding 'icons' to
    # the 'facilities' table and the rest to the 'courts' table.

    # "image_id","image_desc","image_url","image_icon_flag"
    csv_file = File.read('db/data/images.csv')

    csv = CSV.parse(csv_file, :headers => true)

    facility_counter = 0
    court_counter = 0

    csv.each do |row|

      if row[3] == 'true'
        facility = Facility.new

        facility.old_id = row[0]
        facility.name = row[1].split(' icon')[0] # strip "icon." off the end
        facility.image_description = row[1]
        facility.image = row[2].split('.')[0] # strip ".gif" off the end

        facility_counter += 1 if facility.save!
      else
        # Multiple courts have no image available (id = 21)
        courts = Court.where(:old_image_id => row[0])

        courts.each do |court|
          court.image_description = row[1]
          court.image = row[2]

          court_counter += 1 if court.save!(validate: false)
        end
      end

    end

    puts ">>> #{facility_counter} of #{csv.length} were added as facility images"
    puts ">>> #{court_counter} of #{csv.length} were added as court images"

  end

  desc "Import court facilities"
  task :court_facilities => :environment do
    puts "Importing court facilities"

    # "court_access_id","image_id","court_access_desc","court_id"
    csv_file = File.read('db/data/court_access.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      court = Court.find_by_old_id(row[3])

      if court
        puts "Adding #{row[1]} to #{court.name}"

        court_facility = CourtFacility.new

        court_facility.court_id = court.id
        court_facility.facility_id = (Facility.find_by_old_id(row[1]) || next).id
        court_facility.description = Nokogiri::HTML(row[2].strip).inner_text if row[2].present?

        counter += 1 if court_facility.save!
      end
    end

    puts ">>> #{counter} of #{csv.length} court facilities added"

  end

  desc "Import regions"
  task :regions => :environment do
    puts "Importing regions"

    # "court_region_id","court_region_name"
    csv_file = File.read('db/data/court_region.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      puts "Adding region: #{row[1]}"

      region = Region.new

      region.old_id = row[0]
      region.name = row[1]

      counter += 1 if region.save!
    end

    puts ">>> #{counter} of #{csv.length} regions added"

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

  desc "Import areas"
  task :areas => :environment do
    puts "Importing areas"

    # "court_area_id","court_area_name","court_region_id"
    csv_file = File.read('db/data/court_area.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0

    csv.each do |row|
      puts "Adding area: #{row[1]}"

      area = Area.new

      area.old_id = row[0]
      area.name = row[1]
      area.region_id = Region.find_by_old_id(row[2]).id

      counter += 1 if area.save!
    end

    puts ">>> #{counter} of #{csv.length} areas added"

  end

  desc "Import PCOL postcode to court mappings"
  task :postcode_courts => :environment do
    puts "Deleting PostcodeCourt records"
    PostcodeCourt.destroy_all
    puts "Importing PCOL_postcode_to_court_mapping.csv"
    csv_file = File.read('db/data/PCOL_postcode_to_court_mapping.csv')
    csv = CSV.parse(csv_file, :headers => true)
    missing = []
    csv.each do |row|
      puts "Adding postcode to court mapping: #{row[0]}"
      if row[0].present? && row[1].present?
        if court = Court.find_by_cci_code(row[1])
          court.postcode_courts.create!(:postcode => row[0])
        elsif court = Court.find_by_court_number(row[1])
          court.postcode_courts.create!(:postcode => row[0])
        else
          puts "Could not add #{row[0]} #{row[1]} #{row[2]}"
          missing << "#{row[1]} #{row[2]}"
        end
      end
    end
    puts "Summary of missing records: "
    puts missing.uniq
    puts "Finished adding postcode to court mappings."
  end
end
