namespace :maintenance do
  desc "Delete PostcodeCourt records with nil court_ids, created because of an incorrectly defined model association"
  task :clean_postcode_courts => :environment do
    puts "Deleting PostcodeCourt records with nil court_ids"
    PostcodeCourt.where("court_id IS NULL").destroy_all
  end

  desc "Migrate DX data from address to contact_number"
  task :migrate_dx_field_from_address_to_contact_numbers => :environment do
    dx_contact_type = ContactType.find_by_name('DX')
    i = 0

    Court.all.each do |court|
      court.addresses.each do |address|
        unless address.dx.empty?
          if address.dx.match(/\d/).nil?
            puts "Skipped court: #{court.name} with DX entry: #{address.dx}"
            break
          end
          dx_number = address.dx.match(/\d+(.+)/)[0].gsub('.','')
          court.contacts.create!(telephone: dx_number, contact_type_id: dx_contact_type.id, in_leaflet: true)
          puts "For court \'#{court.name}\' extracing dx number from: \'#{address.dx}\' to \'#{dx_number}\'"
          i += 1
        end
      end
    end
    puts "Created #{i} DX records."
  end
end
