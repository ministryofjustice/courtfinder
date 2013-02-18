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
end