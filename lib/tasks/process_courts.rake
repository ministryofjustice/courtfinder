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

  desc "Set type_possession flag to true for existing Possession area of law"
  task :set_type_possession_flag => :environment do
    AreaOfLaw.where("lower(name) like '%possession%'").each do |a|
      a.update_attributes(:type_possession => true)
    end
  end

  desc "Set type_bankruptcy flag to true for existing Bankruptcy area of law"
  task :set_type_bankruptcy_flag => :environment do
    AreaOfLaw.where("lower(name) like '%bankruptcy%'").each do |a|
      a.update_attributes(:type_bankruptcy => true)
    end
  end

  desc "Set type_money_claims flag to true for existing Money Claims courts"
  task :set_type_money_claims_flag => :environment do
    AreaOfLaw.where("lower(name) like '%money claims%'").each do |a|
      a.update_attributes(type_money_claims: true)
    end
  end

  desc "Set type_children flag to true for existing Children courts"
  task :set_type_children_flag => :environment do
    AreaOfLaw.where("lower(name) like '%children%'").each do |a|
      a.update_attributes(type_children: true)
    end
  end

  desc "Set type_adoption flag to true for existing adoption courts"
  task :set_type_adoption_flag => :environment do
    AreaOfLaw.where("lower(name) like '%adoption%'").each do |a|
      a.update_attributes(type_adoption: true)
    end
  end

  desc "Set type_divorce flag to true for existing divorce courts"
  task :set_type_divorce_flag => :environment do
    AreaOfLaw.where("lower(name) like '%divorce%'").each do |a|
      a.update_attributes(type_divorce: true)
    end
  end
end
