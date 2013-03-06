namespace :import do
  
  desc "Import courts"
  task :courts => :environment do
    puts "Importing courts"

    require 'csv'

    csv_file = File.read('db/data/court2.csv')

    csv = CSV.parse(csv_file, :headers => true)

    counter = 0
    
    csv.each do |row|
      o = Court.new

      puts "#{row[1]} #{row[2]}"

      o.old_id = row[0]
      o.name = row[1]
      o.court_number = row[2]           # court_code
      o.info = row[3]
      o.cci_identifier = row[5]
      o.cci_code = row[6]
      o.area_id = row[4]                # some have more than one
      o.old_postal_address_id = row[8]
      o.old_court_address_id = row[7]
      o.old_court_type_id = row[9]

      o.save!
      
      counter += 1
    end

    puts ">>> #{counter} of #{csv.length} courts added"

  end

  desc "Import all address data"
  task :address_data, [:replace] => :environment do | t, args |
    puts "Importing countries, counties, towns"
    puts "Note: This will ADD address data. To replace address data, use:\n  rake 'import:address_data[replace]'"
    puts "If you're on a Windows computer, now is a good time to make a cup of tea"

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

    puts ">>> All done, yay!"
  end
  
  desc "Import areas"
  task :areas => :environment do
    puts "Importing areas"

    require 'csv'

    csv_file = File.read('db/data/areas.csv')

    csv = CSV.parse(csv_file, :headers => true)
    
    csv.each do |row|
      Court.where("area_id = ?", row[0]).each do | court | 
        puts "updating %{court.name}"
        court.area = row[1]
        court.save!
      end
    end

  end
  
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
        # addr.latitude = row[10]
        # addr.longitude = row[11]

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
		court.latitude = row[1]
		court.longitude = row[2]
		court.save!
		
		counter += 1
		
	  end
	end
	
	puts ">>> #{counter} of #{csv.length} coordinates added"
		
  end
  
end