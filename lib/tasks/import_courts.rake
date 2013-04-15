namespace :import do
  
  desc "Import courts"
  task :courts => :environment do
    puts "Importing courts and their types"

    require 'csv'

    csv_file = File.read('db/data/court2.csv')

    # "court_id","court_name","court_code","court_note","court_area_id","court_cci_identifier","court_cci_code","court_addr_id","court_postal_addr_id","court_type_id","borough_search_id","court_code2"
    csv = CSV.parse(csv_file, :headers => true)

    counter = 0
    
    csv.each do |row|
      court = Court.new

      puts "#{row[1]} #{row[2]}"

      court.old_id = row[0]
      court.name = row[1]
      court.court_number = row[2]                     # court_code
      court.info = row[3]
      court.cci_identifier = row[5]
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
      # CourtType.destroy_all
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
    # Rake::Task["import:court_types"].invoke
    Rake::Task["import:courts"].invoke
    Rake::Task["import:address_types"].invoke
    Rake::Task["import:countries"].invoke
    Rake::Task["import:counties"].invoke
    Rake::Task["import:towns"].invoke
    Rake::Task["import:addresses"].invoke
    Rake::Task["import:coordinates"].invoke
    Rake::Task["import:areas_of_law"].invoke
    Rake::Task["import:opening_times"].invoke
    Rake::Task["import:contact_types"].invoke
    Rake::Task["import:contacts"].invoke
    Rake::Task["import:emails"].invoke
    Rake::Task["import:images"].invoke
    Rake::Task["import:court_facilities"].invoke

    puts ">>> All done, yay!"
  end

  desc "Import all address data"
  task :address_data, [:replace] => :environment do | t, args |
    puts "Importing countries, counties, towns"
    puts "Note: This will ADD address data. To replace address data, use:\n  rake 'import:address_data[replace]'"

    if args.replace == 'replace'
      puts "!!! Removing old address data from your database"
      AddressType.destroy_all
      Country.destroy_all
      County.destroy_all
      Town.destroy_all
      Address.destroy_all
    end

    Rake::Task["import:address_types"].invoke
    Rake::Task["import:countries"].invoke
    Rake::Task["import:counties"].invoke
    Rake::Task["import:towns"].invoke
    Rake::Task["import:addresses"].invoke
    Rake::Task["import:coordinates"].invoke

    puts ">>> All done, yay!"
  end
  
  # desc "Import areas"
  # task :areas => :environment do
  #   puts "Importing areas"

  #   require 'csv'

  #   csv_file = File.read('db/data/areas.csv')

  #   csv = CSV.parse(csv_file, :headers => true)
    
  #   csv.each do |row|
  #     Court.where("area_id = ?", row[0]).each do | court | 
  #       puts "updating %{court.name}"
  #       court.area = row[1]
  #       court.save!
  #     end
  #   end

  # end
  
  desc "Import address types"
  task :address_types => :environment do
    puts "Importing address types"

    types = ['Visiting','Postal']
    
    types.each do |i|
      type = AddressType.new

      puts "Adding '#{i}'"

      type.name = i

      type.save!
    end

  end
  
  desc "Import countries"
  task :countries => :environment do
    puts "Importing countries"

    require 'csv'

    csv_file = File.read('db/data/court_country.csv')

    csv = CSV.parse(csv_file)
    
    csv.each do |row|
      country = Country.new

      puts "Adding '#{row[1]}'"

      country.old_id = row[0]
      country.name = row[1]

      country.save!
    end

  end
  
  desc "Import counties"
  task :counties => :environment do
    puts "Importing counties"

    require 'csv'

    csv_file = File.read('db/data/court_county.csv')

    csv = CSV.parse(csv_file)
    
    csv.each do |row|
      county = County.new

      puts "Adding '#{row[1]}'"

      county.old_id = row[0]
      county.name = row[1]
      county.country_id = Country.find_by_old_id(row[2]).id

      county.save!
    end

  end
  
  desc "Import towns"
  task :towns => :environment do
    puts "Importing towns"

    require 'csv'

    csv_file = File.read('db/data/court_town.csv')

    csv = CSV.parse(csv_file)
    
    csv.each do |row|
      town = Town.new

      puts "Adding '#{row[1]}'"

      town.old_id = row[0]
      town.name = row[1]
      town.county_id = County.find_by_old_id(row[2]).id

      town.save!
    end

  end
  
  desc "Import postal court_address"
  task :addresses => :environment do
    puts "Importing court address"

    require 'csv'

    csv_file = File.read('db/data/court_address.csv')

    csv = CSV.parse(csv_file)

    counter = 0

    # id, postal flag, line1, line2...
    csv.each do |row|

      if row[1].to_f == 1
        court = Court.find_by_old_postal_address_id(row[0])
      else
        court = Court.find_by_old_court_address_id(row[0])
      end

      # Only add the address if a court is found
      if court
        puts "Adding '#{row[2]}'"

        addr = Address.new

        if row[1].to_f == 1
          # puts "Looking for court with old postal address id of #{row[0]}"
          addr.court_id = court.id
          addr.address_type_id = 2 # Postal
        else
          addr.court_id = court.id
          addr.address_type_id = 1 # Visiting
        end
        addr.address_line_1 = row[2] unless row[2] == 'NULL'
        addr.address_line_2 = row[3] unless row[3] == 'NULL'
        addr.address_line_3 = row[4] unless row[4] == 'NULL'
        addr.address_line_4 = row[5] unless row[5] == 'NULL'
        addr.postcode = row[6] unless row[6] == 'NULL'
        addr.dx = row[7] unless row[7] == 'NULL'
        addr.town_id = Town.find_by_old_id(row[8]).id

        addr.save!

        counter += 1
      end
    end

    puts ">>> #{counter} of #{csv.length} addresses added"

  end
  
  desc "Import court coordinates"
  task :coordinates => :environment do
    puts "Importing court coordinates"
    
    require 'csv'
    
    csv_file = File.read('db/data/court_coords.csv')
    
    csv = CSV.parse(csv_file)
    
    counter = 0
    
    csv.each do |row|
    
    court = Court.find_by_old_court_address_id(row[0])
      
    if court
      puts "Adding #{row[1]}, #{row[2]}"

      court.latitude = row[1]
      court.longitude = row[2]
      
      counter += 1 if court.save!
    end
  end
  
  puts ">>> #{counter} of #{csv.length} coordinates added"
    
  end
  
  desc "Import court types"
  task :court_types => :environment do
    puts "Importing court types"

    require 'csv'

    csv_file = File.read('db/data/court_type.csv')

    csv = CSV.parse(csv_file, :headers => true)
    
    csv.each do |row|
      type = CourtType.new

      puts "Adding '#{row[1]}'"

      type.old_id = row[0]
      type.old_description = row[1]
      type.name = row[1]
      type.old_ids_split = row[2]

      type.save!
    end

  end
  
  desc "Import areas of law"
  task :areas_of_law => :environment do
    puts "Importing areas of law"

    require 'csv'

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
      area = CourtsAreasOfLaw.new

      puts "Adding '#{row[1]}'"

      area.area_of_law_id = AreaOfLaw.find_by_old_id(row[1]).id
      area.court_id = Court.find_by_old_id(row[2]).id

      area.save!
    end

  end
  
  desc "Import opening types and opening times"
  task :opening_times => :environment do
    puts "Importing opening types and opening times"

    require 'csv'

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

    require 'csv'

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

    require 'csv'

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
        contact.court_id = court.id
        contact.in_leaflet = true

        type = ContactType.find_by_old_id(row[3])
        contact.contact_type_id = type.id if type

        contact.sort = row[4].to_i

        counter += 1 if contact.save!
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
        # "court_contacts_id","court_contacts_name","court_contacts_no","court_id","court_contact_type_id","court_contacts_order"

        contact.name = row[1].strip if row[1].present? and row[1] != 'NULL'
        contact.telephone = row[2] if row[1] != 'NULL'
        contact.court_id = court.id
        contact.in_leaflet = false

        type = ContactType.find_by_old_id(row[4])
        contact.contact_type_id = type.id if type

        contact.sort = row[5].to_i + 1000 # added 1000 to make sure contacts appear after general contacts

        counter += 1 if contact.save!
      end
    end

    puts ">>> #{counter} of #{csv.length} contacts added"

  end

  desc "Import emails"
  task :emails => :environment do
    puts "Importing emails"

    require 'csv'

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

        email.description = row[1].strip if row[1].present?
        email.address = addr if row[2].present?
        email.court_id = court.id

        counter += 1 if email.save!
      end
    end

    puts ">>> #{counter} of #{csv.length} emails addresses added"

  end

  desc "Import images"
  task :images => :environment do
    puts "Importing images"

    require 'csv'

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

        counter += 1 if court.save!
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

      if row[3].to_f == 1 # facility image
        facility = Facility.new

        facility.old_id = row[0]
        facility.name = row[1]
        facility.image_description = row[1]
        facility.image = row[2]

        facility_counter += 1 if facility.save!
      else
        # Multiple courts have no image available (id = 21)
        courts = Court.where(:old_image_id => row[0])

        courts.each do |court|
          court.image_description = row[1]
          court.image = row[2]

          court_counter += 1 if court.save!
        end
      end

    end

    puts ">>> #{facility_counter} of #{csv.length} were added as facility images"
    puts ">>> #{court_counter} of #{csv.length} were added as court images"

  end

  desc "Import court facilities"
  task :court_facilities => :environment do
    puts "Importing court facilities"

    require 'csv'

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
        court_facility.facility_id = Facility.find_by_old_id(row[1]).id
        court_facility.description = row[2].strip if row[2].present?

        counter += 1 if court_facility.save!
      end
    end

    puts ">>> #{counter} of #{csv.length} court facilities added"

  end

  desc "Import regions"
  task :regions => :environment do
    puts "Importing regions"

    require 'csv'

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

  desc "Import areas"
  task :areas => :environment do
    puts "Importing areas"

    require 'csv'

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

end