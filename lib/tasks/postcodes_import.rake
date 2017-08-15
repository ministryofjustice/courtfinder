require 'open-uri'

namespace :postcodes do

  # rake postcodes:import['file_url']
  desc "Load list of postcodes from a CSV file stored on S3"
  task :import, [:file_path] => :environment do |_t, args|
    file_path = args[:file_path]
    imported = 0

    puts "running import from file #{file_path}"
    file = open(file_path)
    CSV.foreach(file, :headers => :first_row) do |row|
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
      postcode: row[0].strip,
      sector: row[1].strip,
      district: row[2].strip,
      area: row[3].strip
    )
  end
end
