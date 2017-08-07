namespace :postcodes do

  # rake postcodes:import['file_path']
  desc "Load list of postcodes from a CSV file"
  task :import, [:file_path] => :environment do |_t, args|
    file_path = args[:file_path]
    i = 0
    imported = 0

    puts "running import from file #{file_path}"
    CSV.foreach(file_path) do |row|
      i += 1
      next if i == 1
      begin
        next if postcode_exist?(row[0])
        create_postcode(row)
        imported += 1
      rescue StandardError => e
        Rails.logger.error "POSTCODE IMPORT: #{row[0]} #{e.message}"
      end
    end
    puts "#{imported} new postcodes imported!"
  end

  def postcode_exist?(postcode)
    OfficialPostcode.find_by(postcode: postcode)
  end

  def create_postcode(row)
    OfficialPostcode.create(
      postcode: row[0],
      sector: row[1],
      district: row[2],
      area: row[3]
    )
  end
end
