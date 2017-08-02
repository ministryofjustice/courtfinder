namespace :postcodes do

  #rake postcodes:import['file_path']
  desc "Load list of postcodes from a CSV file"
  task :import, [:file_path] => :environment do |t, args|
    file_path = args[:file_path]
    i = 0

    puts "running import from file #{file_path}"
    CSV.foreach(file_path) do |row|
      i += 1
      next if i == 1
      begin
        OfficialPostcode.create(
          postcode: row[0],
          sector: row[1],
          district: row[2],
          area: row[3]
        )
      rescue ActiveRecord::RecordNotUnique => e
        Rails.logger.error "POSTCODE IMPORT: #{row[0]} already exists"
      end
    end
    puts "Postcodes imported!"
  end
end
