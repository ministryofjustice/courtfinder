namespace :process do

  desc "Create links between courts and court types"  
  task :court_types => :environment do
    puts "Deleting existing CourtTypesCourt records"
    CourtTypesCourt.destroy_all

    ctypes = CourtType.all.index_by(&:name)

    puts "Assigning new court types"
    Court.all.each do |court|
      court_type_ids = []
      court_type_ids << ctypes["County Court"].id if court.name.downcase.include? "county"
      court_type_ids << ctypes["Magistrates Court"].id if court.name.downcase.include? "magistrate"
      court_type_ids << ctypes["Crown Court"].id if ["crown", "combined"].any? { |t| court.name.downcase.include? t }
      court_type_ids << ctypes["Tribunal"].id if court.name.downcase.include? "tribunal"
      court.update_attributes(:court_type_ids => court_type_ids)
    end
  end

  desc "Assign type 'Visiting' to all addresses marked as primary"
  task :court_addresses => :environment do
    v = AddressType.find_or_create_by_name("Visiting")
    Address.where(is_primary: true).each { |ad| ad.update_attributes(:address_type_id => v.id) }
  end
end