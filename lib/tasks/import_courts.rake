namespace :import do
  
  desc "Import courts"
  task :courts => :environment do
    puts "Importing courts"

    require 'csv'

    csv_file = File.read('db/data/court2.csv')

    csv = CSV.parse(csv_file, :headers => true)
    
    csv.each do |row|
      o = Court.new

      puts "#{row[1]} #{row[2]}"

      o.name = row[1]
      o.court_number = row[2]
      o.info = row[3]
      o.cci_identifier = row[5]
      o.cci_code = row[6]
	  o.area_id = row[4]
	  o.old_id = row[0]
	  o.old_postal_address_id = row[7]
	  o.old_court_address_id = row[8]
	  o.old_court_type_id = row[9]

      o.save!
    end

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
  
    desc "Import postal court_address"
    task :court_address => :environment do
		puts "Importing court address"

    require 'csv'

    csv_file = File.read('db/data/court_address.csv')

    csv = CSV.parse(csv_file, :headers => true)
    
    csv.each do |row|
		Court.where("old_court_address_id = ? OR old_postal_address_id = ?", row[0], row[]).each do | court | 
			puts "updating %{court.name}"
			court.address_line_1 = row[2]
			court.address_line_2 = row[3]
			court.address_line_3 = row[4]
			court.address_line_4 = row[5]
			court.postcode = row[6]
			court.dx_number = row[7]
			court.court_town_id = row[8]
			court.court_latitude = row[10]
			court.court_longitude = row[11]
			court.save!
		end
    end

  end
  
  
end